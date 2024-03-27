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

variable "env_var_profile" {
    description = "The app profile. Should be cloud, env  where env is one of prd or dev or qa"
}

variable "env_var_port" {
    description = "The app is listening on"
}

variable "env_var_db_url" {
    description = "The DB url"
}

variable "env_var_db_username" {
    description = "The DB username"
}

variable "env_var_db_password" {
    description = "The DB password"
}

variable "env_var_jwt_secret" {
    description = "The app JWT secret"
}

variable "env_var_stripe_secret" {
    description = "The app Stripe secret"
}

variable "env_var_log_level" {
    description = "The app log level like DEBUG or INFO"
}

variable "env_var_log_http_request" {
    description = "The app log http request"
}

variable "env_var_log_http" {
    description = "Log http level like DEBUG or INFO"
}

variable "env_var_log_db" {
    description = "Log DB level like DEBUG or INFO"
}