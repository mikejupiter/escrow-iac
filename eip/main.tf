provider "aws" {
  region = "us-east-1"  # Replace with your desired AWS region
}

resource "aws_eip" "jumpbox_eip" {
  instance = null # EIP will be created without an instance initially
}

output "eip_id" {
  value = aws_eip.my_eip.id
}
