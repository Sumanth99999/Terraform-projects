module "aws_instance" {
  source = "./Module"
  ami = var.default-ami
  instance-types = var.default-instance-type
  
}

