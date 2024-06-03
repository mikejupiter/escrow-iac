provider "aws" {
  region = var.aws_region
}

module "alb" {
  source = "./alb"

  aws_region       = var.aws_region
  vpc_id           = var.vpc_id
  subnets          = var.subnets
}

module "ecs" {
  source = "./ecs"

  aws_region               = var.aws_region
  target_group_arn         = module.alb.target_group_arn
  vpc_id                   = var.vpc_id
  subnets                  = var.subnets
  aws_ecs_cluster_arn      = var.aws_ecs_cluster_arn
  ecs_service_name         = var.ecs_service_name
  ecs_task_definition_name = var.ecs_task_definition_name
  docker_image_name        = var.docker_image_name
  ecs_service_exec_role    = var.ecs_service_exec_role

  awslogs_create_group     = var.awslogs_create_group
  awslogs_group            = var.awslogs_group
  awslogs_stream_prefix    = var.awslogs_stream_prefix
  
  env_var_profile          = var.env_var_profile
  env_var_port             = var.env_var_port
  env_var_db_url           = var.env_var_db_url
  env_var_db_username      = var.env_var_db_username
  env_var_db_password      = var.env_var_db_password
  env_var_jwt_secret       = var.env_var_jwt_secret
  env_var_stripe_secret    = var.env_var_stripe_secret
  env_var_log_level        = var.env_var_log_level
  env_var_log_http_request = var.env_var_log_http_request
  env_var_log_http         = var.env_var_log_http
  env_var_log_db           = var.env_var_log_db

}


