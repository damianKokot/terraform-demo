variable "memory_size" {
  description = "Amount of memory that should be assigned into instance in MiB"
  type        = number
  default     = 512
}

variable "cpu_size" {
  description = "Amount of cpu that should be assigned into instance"
  type        = number
  default     = 256
}

variable "docker_image" {
  description = "Docker image that should be running"
  type        = string
}

variable "app_port" {
  description = "Port that app is exposing"
  type        = number
  default     = 3000
}

variable "instances_count" {
  description = "Number of instances that should be running in ECS task"
  type        = number
  default     = 3
}

variable "environment_variables" {
  description = "Env vars that should be exported inside container"
  type        = map(string)
}
