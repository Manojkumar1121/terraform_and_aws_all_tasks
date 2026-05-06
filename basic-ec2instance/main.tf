provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0a91cd140a1fc148a"  
  instance_type = "t3.micro"

  tags = {
    Name = "ec2-instance"
  }
}