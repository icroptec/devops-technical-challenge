variable "project_name"   { type = string }
variable "environment"    { type = string }
variable "region"         { type = string }
variable "container_port" { type = number }
variable "desired_count"  { type = number }
variable "cpu"            { type = number }
variable "memory"         { type = number }
variable "image"          { type = string, default = "" }
