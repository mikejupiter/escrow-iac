variable "aws_region" {
    description = "The AWS log region"
}

variable "vpc_id" {}
variable "subnets" {
  type = list(string)
}


