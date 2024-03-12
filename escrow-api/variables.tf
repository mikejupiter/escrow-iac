# variables.tf
variable "aws_region" {}
variable "vpc_id" {}
variable "subnets" {
  type = list(string)
}
variable "ecs_cluster_name" {}
variable "ecs_service_name" {}
variable "ecs_task_definition_name" {}
variable "docker_image_name" {}
