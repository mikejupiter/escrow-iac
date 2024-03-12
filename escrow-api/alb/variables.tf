variable "vpc_id" {}
variable "subnets" {
  type = list(string)
}
variable "ecs_cluster_name" {}
variable "ecs_service_name" {}
