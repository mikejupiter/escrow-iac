provider "aws" {
  region = "us-east-1"  # Replace with your desired AWS region
}

resource "aws_eip" "jumpbox_eip" {
  instance = null # EIP will be created without an instance initially
}

output "eip_id" {
  value = aws_eip.jumpbox_eip.id
}

output "eip_public_ip" {
  value = aws_eip.jumpbox_eip.public_ip
}
