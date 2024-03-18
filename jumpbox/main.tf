provider "aws" {
  region = "us-east-1"  # Replace with your desired AWS region
}

data "aws_eip" "jumpbox_eip" {
  id = "eipalloc-0599652edad8e6d12"  # 54.164.209.95
}

# Create a security group for RDP access
resource "aws_security_group" "rdp_sg" {
  name        = "allow_rdp"
  description = "Allow RDP traffic from your IP address"

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a security group for WinRM access
resource "aws_security_group" "winrm_sg" {
  name        = "allow_winrm"
  description = "Allow WinRM traffic for Ansible"

  ingress {
    from_port   = 5985
    to_port     = 5985
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Replace with your internal network CIDR
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jumpbox" {
  ami           = "ami-000551805fdaf7e28"  # 64-bit (x86) Microsoft Windows 2022 Datacenter Core edition
  instance_type = "t2.medium"

  security_groups = [aws_security_group.rdp_sg.name, aws_security_group.winrm_sg.name]

  tags = {
    Name = "Jumpbox"
  }

  network_interface {
    device_index          = 0
    network_interface_id  = data.aws_eip.jumpbox_eip.network_interface_id
  }
}

output "public_ip" {
  value = aws_instance.jumpbox.public_ip
}

output "administrator_password" {
  value = aws_instance.jumpbox.password_data
}