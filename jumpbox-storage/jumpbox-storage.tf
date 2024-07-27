
provider "aws" {
  region = "us-east-1"
}

resource "aws_ebs_volume" "jumpbox_storage" {
  availability_zone = "us-east-1a"  # Replace with your desired availability zone
  size              = 64             # The size of the volume in GiB
  type              = "gp3"
  
  tags = {
    Name = "JumpboxPermanentDisk"
  }
}
