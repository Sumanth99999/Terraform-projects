resource "aws_instance" "demo1" {
  ami = var.default-ami
  instance_type = var.default-instance-type
  security_groups = [aws_security_group.SG1.id]
}