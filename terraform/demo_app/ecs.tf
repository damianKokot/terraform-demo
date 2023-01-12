##############
# ECS Cluser #
##############
resource "aws_ecs_cluster" "terraform_demo_cluster" {
  name = "terraform-demo-cluster"

  tags = {
    managed_by : "terraform"
  }
}

#######################
# ECS Task definition #
#######################
resource "aws_ecs_task_definition" "terraform_demo_task" {
  family = "terraform_demo_task" # Naming our first task
  container_definitions = jsonencode([
    {
      name      = "terraform_demo_task",
      image     = var.docker_image,
      essential = true,
      portMappings = [
        {
          protocol      = "tcp"
          containerPort = var.app_port,
          hostPort      = var.app_port
        }
      ],
      environment = [
        for name, value in var.environment_variables : { name = name, value = value }
      ]
      memory      = var.memory_size,
      cpu         = var.cpu_size,
      volumesFrom = [],
      mountPoints = []
    }
  ])

  requires_compatibilities = ["FARGATE"]     # Stating that we are using ECS Fargate
  network_mode             = "awsvpc"        # Using awsvpc as our network mode as this is required for Fargate
  memory                   = var.memory_size # Specifying the memory our container requires
  cpu                      = var.cpu_size    # Specifying the CPU our container requires
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  tags = {
    managed_by : "terraform"
  }
}

###############
# ECS Service #
###############
resource "aws_ecs_service" "terraform_demo_service" {
  name            = "terraform-demo-service"                        # Naming our first service
  cluster         = aws_ecs_cluster.terraform_demo_cluster.id       # Referencing our created Cluster
  task_definition = aws_ecs_task_definition.terraform_demo_task.arn # Referencing the task our service will spin up
  launch_type     = "FARGATE"
  desired_count   = 3 # Setting the number of containers we want deployed to 1

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn # Referencing our target group
    container_name   = aws_ecs_task_definition.terraform_demo_task.family
    container_port   = var.app_port # Specifying the container port
  }

  network_configuration {
    subnets          = ["${aws_default_subnet.default_subnet_a.id}", "${aws_default_subnet.default_subnet_b.id}", "${aws_default_subnet.default_subnet_c.id}"]
    assign_public_ip = true                                                # Providing our containers with public IPs
    security_groups  = ["${aws_security_group.service_security_group.id}"] # Setting the security group
  }

  tags = {
    managed_by : "terraform"
  }
}