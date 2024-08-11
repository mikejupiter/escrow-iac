variable "aws_region" {
    default = "us-east-1"
    description = "The AWS log region"
}
variable "availability_zone" {
    default = "us-east-1a"
    description = "The AWS log region"
}
variable "vpc_cidr" {
    description = "Internal IP range"
}

# variable "vpc_id" {}
# variable "subnets" {
#   type = list(string)
# }

variable "eip" {}
variable "admin_password" {}

variable "jumpbox_volume_id" {
  description = "The ID of the EBS volume to attach Jumpbox persisted data"
  type        = string
}

variable "route53_zone_id" {
  description = "The ID of private Route53 zone"
  type        = string
}
