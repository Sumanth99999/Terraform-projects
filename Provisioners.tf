provider "aws" {
  region = "ap-south-1"
}


resource "aws_vpc" "vpc-1" {
  cidr_block = var.cidr_block
}


resource "aws_subnet" "public" {
  cidr_block = var.subnet-1
  vpc_id = aws_vpc.vpc-1
}

resource "aws_internet_gateway" "Entry" {
  vpc_id = aws_vpc.vpc-1
}

resource "aws_route_table" "Route" {
  vpc_id = aws_vpc.vpc-1.id
  route{
    gateway_id = aws_internet_gateway.Entry.id
    cidr_block = "0.0.0.0/0"
  }
}

resource "aws_route_table_association" "path" {
  route_table_id = aws_route_table.Route.id
  subnet_id = aws_subnet.public.id
}



resource "aws_security_group" "incoming" {
    name = ssh
    vpc_id = aws_vpc.vpc-1.id
    ingress{
        description = "allow ssh"
        from_port = "22"
        to_port = "22"
        protocol = "tcp"
        cidr_blocks = "0.0.0.0/0"
    }

    ingress{
        description = "allow port 5000"
        from_port = "5000"
        to_port = "5000"
        protocol = "tcp"
        cidr_blocks = "0.0.0.0/0"
    }

    egress {
        description = "allow all traffic"
        from_port = "0"
        to_port = "0"
        protocol = "-1"
        cidr_blocks = "0.0.0.0/0"
    }
        
}

resource "aws_instance" "EC-2" {
  ami = var.default-ami
  instance_type = var.default-instance-type
  subnet_id = aws_subnet.public.id
  vpc_security_group_ids = [aws_vpc.vpc-1.id]

  connection {
    type = "ssh"
    user = "ubuntu"
    host = self.public_ip
  }
}
