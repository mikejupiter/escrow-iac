provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "example_key" {
  key_name   = "example-key"
  public_key = file("../secrets/example_id_rsa.pub")  
}


resource "aws_security_group" "example_ssh_sg" {
  name        = "example-ssh-sg"
  description = "Allow inbound SSH traffic"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from any IP address
  }
}

resource "aws_instance" "example" {
  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.micro"

  key_name      = aws_key_pair.example_key.key_name  

  tags = {
    Name        = "example"  
  }

  vpc_security_group_ids = [aws_security_group.example_ssh_sg.id]
}

output "instance_id" {
  value = aws_instance.example.id
}