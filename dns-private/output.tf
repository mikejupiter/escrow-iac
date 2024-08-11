# Output the hosted zone ID and DNS name
output "route53_zone_id" {
  value = aws_route53_zone.private_zone.zone_id
  description = "The ID of the private Route 53 hosted zone"
}
