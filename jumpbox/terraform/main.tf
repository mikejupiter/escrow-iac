provider "aws" {
  region = var.aws_region  # Replace with your desired AWS region
}

data "aws_eip" "jumpbox_eip" {
  id = var.eip
}

resource "aws_key_pair" "jumpbox_key" {
  key_name   = "jumpbox-key"
  public_key = file("../../secrets/jumpbox_id_rsa.pub")  
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
    from_port   = 5986
    to_port     = 5986
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
  ami           = "ami-0f9c44e98edf38a2b"  # 64-bit (x86) Microsoft Windows 2022 Datacenter edition. [English]
  instance_type = "t2.medium"
  availability_zone = var.availability_zone

  key_name      = aws_key_pair.jumpbox_key.key_name  

  tags = {
    Name = "Jumpbox"
  }

  security_groups = [
    aws_security_group.rdp_sg.name,
    aws_security_group.winrm_sg.name
  ]

  # User data script to enable WinRM for Ansible
  user_data = templatefile("${path.module}/startup.ps1.tpl", {
    admin_password = var.admin_password
  })
  user_data_replace_on_change = true
}

resource "aws_eip_association" "eip_jumpbox_assoc" {
  instance_id   = aws_instance.jumpbox.id
  allocation_id = data.aws_eip.jumpbox_eip.id
}

resource "aws_volume_attachment" "ebs_attachment" {
  device_name = "/dev/sdh"
  volume_id   = var.jumpbox_volume_id
  instance_id = aws_instance.jumpbox.id
}
