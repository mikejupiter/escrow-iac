provider "aws" {
  region = var.aws_region
}

locals {
  ecs_task_definition_template = templatefile("${path.module}/ecs_task_definition.json.tpl", {
    docker_image_name               = var.docker_image_name,
    env_var_port                    = var.env_var_port,
    awslogs_region                  = var.aws_region,
    awslogs_group                   = var.awslogs_group,
    awslogs_stream_prefix           = var.awslogs_stream_prefix,
    awslogs_create_group            = var.awslogs_create_group,

    env_var_profile                 = var.env_var_profile,
    env_var_db_url                  = var.env_var_db_url,
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
  cpu                      = 256
  memory                   = 1024
  family                   = var.ecs_task_definition_name
  container_definitions    = local.ecs_task_definition_template
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_service_exec_role
}

resource "aws_ecs_service" "service" {
  name            = var.ecs_service_name
  cluster         = var.aws_ecs_cluster_arn
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 1

  network_configuration {
    subnets          = var.subnets
    #assign_public_ip = false
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs_service.id]
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "escrow-api-container"  # Replace with the name of your container
    container_port   = 8080  # Replace with the port your container listens on
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

# Define Auto Scaling Policies
# resource "aws_appautoscaling_target" "ecs_target" {
#   max_capacity       = var.max_capacity
#   min_capacity       = var.min_capacity
#   resource_id        = "service/${var.aws_ecs_cluster_arn}/${aws_ecs_service.service.name}"
#   scalable_dimension = "ecs:service:DesiredCount"
#   service_namespace  = "ecs"
# }

# resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
#   name               = "cpu-scaling-policy"
#   policy_type        = "TargetTrackingScaling"
#   resource_id        = aws_appautoscaling_target.ecs_target.resource_id
#   scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
#   service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

#   target_tracking_scaling_policy_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ECSServiceAverageCPUUtilization"
#     }
#     scale_out_cooldown    = var.scale_out_cooldown
#     scale_in_cooldown     = var.scale_in_cooldown
#     target_value          = var.target_cpu_utilization
#   }
# }


