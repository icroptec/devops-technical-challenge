resource "aws_security_group" "svc" {
  name   = "${var.project_name}-${var.environment}-svc-sg"
  vpc_id = aws_vpc.vpc.id
  ingress { from_port=var.container_port, to_port=var.container_port, protocol="tcp", security_groups=[aws_security_group.alb.id] }
  egress  { from_port=0, to_port=0, protocol="-1", cidr_blocks=["0.0.0.0/0"] }
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = "/ecs/${var.project_name}-${var.environment}"
  retention_in_days = 14
}

resource "aws_ecs_cluster" "cluster" {
  name = "${var.project_name}-${var.environment}"
}

locals {
  image_uri = var.image != "" ? var.image : "${aws_ecr_repository.repo.repository_url}:latest"
}

resource "aws_ecs_task_definition" "task" {
  family                   = "${var.project_name}-${var.environment}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.task_execution.arn
  task_role_arn            = aws_iam_role.task.arn

  container_definitions = jsonencode([{
    name  = "app"
    image = local.image_uri
    portMappings = [{ containerPort = var.container_port, hostPort = var.container_port, protocol = "tcp" }]
    secrets = [{
      name      = "OPENWEATHER_API_KEY"
      valueFrom = aws_secretsmanager_secret.openweather.arn
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.logs.name
        awslogs-region        = var.region
        awslogs-stream-prefix = "ecs"
      }
    }
  }])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

resource "aws_ecs_service" "svc" {
  name            = "${var.project_name}-${var.environment}"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"
  network_configuration {
    subnets         = aws_subnet.private[*].id
    security_groups = [aws_security_group.svc.id]
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.tg.arn
    container_name   = "app"
    container_port   = var.container_port
  }
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  depends_on = [aws_lb_listener.http]
}

output "service_name" { value = aws_ecs_service.svc.name }
