#Defining the provider
provider "aws" {
  region = "ap-south-1"
}

#Creating a vpc
resource "aws_vpc" "vpc-1" {
  cidr_block = var.cidr_block
}

#Craeating a subnet inside the vpc
resource "aws_subnet" "public" {
  cidr_block = var.subnet-1
  vpc_id = aws_vpc.vpc-1.id
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true
}

#creating a internet gateway
resource "aws_internet_gateway" "Entry" {
  vpc_id = aws_vpc.vpc-1.id
}

#Attaching a Route table with vpc
resource "aws_route_table" "Route" {
  vpc_id = aws_vpc.vpc-1.id
  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Entry.id
    
  }
}

#Attaching Route table with public subnet
resource "aws_route_table_association" "path" {
  route_table_id = aws_route_table.Route.id
  subnet_id = aws_subnet.public.id
}

#Creating a keypair to login via ssh
resource "aws_key_pair" "KP" {
  key_name = "aws_login"
  public_key = file("~/.ssh/id_rsa.pub")
}

#Creating security groups
resource "aws_security_group" "incoming" {
    vpc_id = aws_vpc.vpc-1.id
    ingress{
        description = "allow ssh"
        from_port = "22"
        to_port = "22"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
#Inbound traffic
    ingress{
        description = "allow port 5000"
        from_port = "5000"
        to_port = "5000"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
#Outbound traffic
    egress {
        description = "allow all traffic"
        from_port = "0"
        to_port = "0"
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
        
}

#Creating an EC2 instance
resource "aws_instance" "EC-2" {
  ami = var.default-ami
  instance_type = var.default-instance-type
  key_name = aws_key_pair.KP.id
  subnet_id = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.incoming.id]

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [ 
      "sudo apt update -y",
      "sudo apt install docker.io -y",
      "sudo systemctl enable docker",
      "sudo systemctl start docker ",
      "sudo docker pull sumanthreddy1242/intrusion-detection",
      "sudo docker run -d -p 5000:5000 sumanthreddy1242/intrusion-detection"
     ]
  }
  
  provisioner "file" {
    source = "userdata1.sh"
    destination = "~/Project/userdata1.sh"
  }

  provisioner "local-exec" {
    command = "echo Deployment completed"
  }
}

output "aws_instance" {
  value = "aws_instance.EC-2.public_ip"
}