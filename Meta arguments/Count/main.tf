provider "aws" {
  region = "ap-south-1"
}

#Creates the 5 instances with same configuration
resource "aws_instance" "EC2" {
  ami = "ami-0ad21ae1d0696ad58"
  instance_type = "t2.micro"
  count = 5

  #Here we used to name the number starting from 1
  tags = {
    Name = "Instance ${count.index}"
  }
}