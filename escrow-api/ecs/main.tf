resource "aws_ecs_cluster" "cluster" {
  name = var.ecs_cluster_name
}

locals {
  ecs_task_definition_template = templatefile("${path.module}/ecs_task_definition.json.tpl", {
    docker_image_name               = var.docker_image_name,
    env_var_port                    = var.env_var_port,
    awslogs_region                  = var.awslogs_region,
    awslogs_group                   = var.awslogs_group,
    awslogs_stream_prefix           = var.awslogs_stream_prefix,
    awslogs_create_group            = var.awslogs_create_group,

    env_var_profile                 = var.env_var_profile,
    env_var_db_url                  = env_var_db_url,
    env_var_db_username             = var.env_var_db_username,
    env_var_db_password             = var.env_var_db_password,
    env_var_jwt_secret              = var.env_var_jwt_secret,
    env_var_stripe_secret           = var.env_var_stripe_secret,
    env_var_log_level               = var.env_var_log_level,
    env_var_log_http_request        = var.env_var_log_http_request,
    env_var_log_http                = var.env_var_log_http,
    env_var_log_db                  = var.env_var_log_db

  })
}

resource "aws_ecs_task_definition" "task_definition" {
  family                   = var.ecs_task_definition_name
  container_definitions    = local.ecs_task_definition_template
}

resource "aws_ecs_service" "service" {
  name            = var.ecs_service_name
  cluster         = aws_ecs_cluster.cluster.arn
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnets
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs_service.id]
  }
}

resource "aws_security_group" "ecs_service" {
  name        = "ecs-service-sg"
  description = "Security group for ECS service"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
