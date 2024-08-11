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
    aws_security_group.winrm_sg.name,
    aws_security_group.https_sg,
    aws_security_group.pg_sg,
    aws_security_group.master_jenkins_sg,
    aws_security_group.jenkins_callback_sg
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

resource "aws_route53_record" "jumpbox_private_ip" {
  zone_id = var.route53_zone_id  # Your Route 53 hosted zone ID
  name    = "jenkins.private"    # Your custom internal DNS name
  type    = "A"

  ttl     = 60
  records = [aws_instance.jumpbox.private_ip]  # Use the private IP of the instance

  depends_on = [aws_instance.jumpbox]
}