terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.48.0"
    }
  }
}

provider "aws" {
  region  = "eu-central-1"
  profile = "damian_sandbox"
}


module "demo_app" {
  source = "./demo_app"

  docker_image    = "1837/hostname_node_env_app:v1"
  app_port        = 3000
  instances_count = 3

  environment_variables = {
    ENVIRONMENT_NAME = "terraform",
    NODE_ENV         = "development"
  }
}

output "dns_name" {
  value = module.demo_app.dns_name
}

output "container_definitions" {
  value = module.demo_app.container_definitions
}
