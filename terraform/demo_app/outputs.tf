output "dns_name" {
  value = aws_alb.application_load_balancer.dns_name
}

output "container_definitions" {
  value = jsondecode(
    aws_ecs_task_definition.terraform_demo_task.container_definitions
  )
}
