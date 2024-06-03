output "escrow_alb_id" {
  value = aws_lb.escrow_alb.arn
}

output "escrow_alb_dns_name" {
  value = aws_lb.escrow_alb.dns_name
}

output "alb_security_group_id" {
  value = aws_security_group.alb_sg.id
}

output "target_group_arn" {
  value = aws_lb_target_group.escrow_api_target_group.arn
}