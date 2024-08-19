
resource "aws_instance" "Ec2" {
  ami = var.ami
  instance_type = lookup(var.instance_type, terraform.workspace, "t2.micro")

}
