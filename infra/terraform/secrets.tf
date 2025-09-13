resource "aws_secretsmanager_secret" "openweather" {
  name = "${var.project_name}/${var.environment}/OPENWEATHER_API_KEY"
}
resource "aws_secretsmanager_secret_version" "openweather_v" {
  secret_id     = aws_secretsmanager_secret.openweather.id
  secret_string = jsonencode({ OPENWEATHER_API_KEY = "ffeac58c055a05f96936fdccf74e3c6d" })
}
output "openweather_secret_arn" { value = aws_secretsmanager_secret.openweather.arn }
