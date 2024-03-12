variable "vpc_id" {}
variable "subnets" {
  type = list(string)
}
variable "ecs_cluster_name" {}
variable "ecs_service_name" {}
variable "ecs_task_definition_name" {
    description = "ECS task definition name"
}
variable "docker_image_name" {
    description = "Name of the Docker image to use in the ECS task definition"
}
