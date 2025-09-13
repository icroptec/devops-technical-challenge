resource "aws_iam_role" "task_execution" {
  name = "${var.project_name}-${var.environment}-exec"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{ Effect="Allow", Principal={ Service="ecs-tasks.amazonaws.com" }, Action="sts:AssumeRole" }]
  })
}
resource "aws_iam_role_policy_attachment" "exec" {
  role       = aws_iam_role.task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "task_role" {
  name = "${var.project_name}-${var.environment}-task"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{ Effect="Allow", Principal={ Service="ecs-tasks.amazonaws.com" }, Action="sts:AssumeRole" }]
  })
}

resource "aws_iam_policy" "secrets" {
  name   = "${var.project_name}-${var.environment}-secrets"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect="Allow",
      Action=["secretsmanager:GetSecretValue"],
      Resource="*"
    }]
  })
}
resource "aws_iam_role_policy_attachment" "task_secrets" {
  role       = aws_iam_role.task_role.name
  policy_arn = aws_iam_policy.secrets.arn
}

output "task_execution_role_arn" { value = aws_iam_role.task_execution.arn }
output "task_role_arn"           { value = aws_iam_role.task_role.arn }
