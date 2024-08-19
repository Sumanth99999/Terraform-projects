provider "aws" {
  alias = "Region-1"
  region = "ap-south-1a"
}

provider "aws" {
  alias = "Region-2"
  region = "ap-south-1b"
}

resource "aws_instance" "demoo-1" {
  ami = var.default-ami
  instance_type = var.default-instance-type
  provider = aws.Region-1
}

resource "aws_instance" "demoo-2" {
  ami = var.default-ami
  instance_type = var.default-instance-type
  provider = aws.Region-2
}