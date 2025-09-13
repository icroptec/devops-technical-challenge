resource "aws_ecr_repository" "repo" {
  name = "${var.project_name}-${var.environment}"
  image_scanning_configuration { scan_on_push = true }
  force_delete = true
}

output "ecr_repo" { value = aws_ecr_repository.repo.repository_url }
