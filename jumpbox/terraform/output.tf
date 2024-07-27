output "public_ip" {
  value = aws_instance.jumpbox.public_ip
}

output "administrator_password" {
  value = aws_instance.jumpbox.password_data
}

output "aws-output" {
  value = <<OUTPUT
  
#############  
## OUTPUTS ##
#############

Admin Password: ${var.admin_password}

  

#############
## DESTROY ##
#############

# To destroy the project via terraform, run:
terraform destroy -var-file="./env/<env>.tfvars"

OUTPUT
}