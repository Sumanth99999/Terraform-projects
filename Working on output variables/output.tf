#Mentioning the cloud provider
provider "aws" {
  region = "ap-south-1"
}

#Creating VPC
resource "aws_vpc" "VPC" {
  cidr_block = "10.0.0.0/16"
}

#Creating a public sunet inside the vpc
resource "aws_subnet" "public" {
  vpc_id = aws_vpc.VPC.id
  cidr_block = "10.0.0.0/24"
}

#Creating an EC2 instance inside the public subnet
resource "aws_instance" "EC2" {
  ami = "ami-0ad21ae1d0696ad58"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public.id
}

#Printing the ip address to terminal using output keyword
output "public-ip-address" {
  value = aws_instance.EC2.id
}

#Printing vpc id
output "aws_vpc" {
  value = aws_vpc.VPC.id
}

#Printing subnet id
output "aws_subnet" {
  value = aws_subnet.public.id
}
