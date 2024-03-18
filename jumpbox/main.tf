provider "aws" {
  region = "us-east-1"  # Replace with your desired AWS region
}

data "aws_eip" "jumpbox_eip" {
  id = "eipalloc-0599652edad8e6d12"  # 54.164.209.95
}

resource "aws_key_pair" "jumpbox_key" {
  key_name   = "jumpbox-key"
  public_key = file("../secrets/jumpbox_id_rsa.pub")  
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
  ami           = "ami-0f9c44e98edf38a2b"  # 64-bit (x86) Microsoft Windows 2022 Datacenter edition. [English]
  instance_type = "t2.medium"

  key_name      = aws_key_pair.jumpbox_key.key_name  

  tags = {
    Name = "Jumpbox"
  }

  security_groups = [
    aws_security_group.rdp_sg.name,
    aws_security_group.winrm_sg.name
  ]

  # User data script to enable WinRM for Ansible
  user_data = <<-EOF
    <powershell>
      # Enable WinRM
      Enable-PSRemoting -Force

      # Allow connections from all hosts (use specific IPs for security)
      Set-Item WSMan:\localhost\Client\TrustedHosts -Value "*" -Force

      # Allow basic authentication (needed by Ansible)
      Set-Item WSMan:\localhost\Service\Auth\Basic -Value $true -Force

      # Restart WinRM service
      Restart-Service -Name WinRM

      # Configure Windows Firewall to allow RDP
      New-NetFirewallRule -DisplayName "Allow RDP" -Direction Inbound -LocalPort 3389 -Protocol TCP -Action Allow
    </powershell>
  EOF
}

resource "aws_eip_association" "eip_jumpbox_assoc" {
  instance_id   = aws_instance.jumpbox.id
  allocation_id = data.aws_eip.jumpbox_eip.id
}

output "public_ip" {
  value = aws_instance.jumpbox.public_ip
}

output "administrator_password" {
  value = aws_instance.jumpbox.password_data
}