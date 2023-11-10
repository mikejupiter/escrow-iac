provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "example_key" {
  key_name   = "example-key"
  public_key = file("../secrets/example_id_rsa.pub")  
}

resource "aws_instance" "example" {
  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.micro"

  key_name      = aws_key_pair.example_key.key_name  

  tags = {
    Name        = "example"  
    InstanceID  = aws_instance.example.id  
  }
}