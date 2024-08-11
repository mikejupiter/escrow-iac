provider "aws" {
  region = var.aws_region
}

# Create a private Route 53 hosted zone
resource "aws_route53_zone" "private_zone" {
  name = "private"  # Replace with your desired private domain name (e.g., 'private')
  vpc {
    vpc_id = var.vpc_id
  }
  comment = "Private hosted zone for internal services"

}