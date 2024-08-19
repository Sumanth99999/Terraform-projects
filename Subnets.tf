resource "aws_subnet" "subnet-1" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.subnet-1
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet-2" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.subnet-2
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = true
}