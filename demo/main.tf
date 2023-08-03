provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_instance" "hello" {
  ami           = "ami-03ae37b34d7fea1cd"
  instance_type = "t2.micro"
  tags = {
    Name = "HelloWorld"
  }
}