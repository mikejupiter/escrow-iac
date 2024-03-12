provider "aws" {
  region = var.aws_region
}

module "ecs" {
  source = "./ecs"

  vpc_id                  = var.vpc_id
  subnets                 = var.subnets
  ecs_cluster_name        = var.ecs_cluster_name
  ecs_service_name        = var.ecs_service_name
  ecs_task_definition_name = var.ecs_task_definition_name
  docker_image_name       = var.docker_image_name
}

module "alb" {
  source = "./alb"

  vpc_id           = var.vpc_id
  subnets          = var.subnets
  target_group_arn = module.ecs.target_group_arn
}
