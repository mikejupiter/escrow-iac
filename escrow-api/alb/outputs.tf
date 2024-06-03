output "escrow_alb_id" {
  value = aws_lb.escrow_alb.arn
}

output "escrow_alb_dns_name" {
  value = aws_lb.escrow_alb.dns_name
}


output "target_group_arn" {
  value = aws_lb_target_group.escrow_api_target_group.arn
}