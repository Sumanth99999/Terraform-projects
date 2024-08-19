variable "ami" {
  description = "AMI"
}

variable "instance-types" {
  description = "Defualt Instance type"
}

resource "aws_instance" "server-1" {
  ami = var.ami
  instance_type = var.instance-types
}