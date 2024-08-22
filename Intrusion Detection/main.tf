# Creating a VPC
resource "aws_vpc" "VPC" {
  cidr_block = var.subnet_cidr
}

# Creating Public Subnet-1
resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.VPC.id
  cidr_block              = var.subnet_cidr
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
}

# Creating Public Subnet-2
resource "aws_subnet" "subnet2" {
  vpc_id                  = aws_vpc.VPC.id
  cidr_block              = var.subnet_cidr
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true
}

# Creating Internet Gateway
resource "aws_internet_gateway" "IG" {
  vpc_id = aws_vpc.VPC.id
}

# Creating Route Table
resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IG.id
  }
}

#Creating key value pair
resource "aws_key_pair" "KP" {
  key_name = "login"
  public_key = file("~/.ssh/id_rsa.pub")
}

# Associating Route Table with Subnets
resource "aws_route_table_association" "Assoc1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_route_table_association" "Assoc2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.RT.id
}

# Creating Security Group
resource "aws_security_group" "SG" {
  name   = "public"
  vpc_id = aws_vpc.VPC.id

  # Inbound Traffic
  ingress {
    description = "Allow traffic from HTTP"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Traffic from SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound Traffic
  egress {
    description = "Allow all outbound Traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Creating IAM Role
resource "aws_iam_role" "ec2_role" {
  name = "ec2_s3_access_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# Creating IAM Policy
resource "aws_iam_policy" "s3_policy" {
  name        = "s3_access_policy"
  description = "Policy to allow EC2 instances to access S3"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:*"]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

# Attaching IAM Policy to Role
resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.ec2_role.id
  policy_arn = aws_iam_policy.s3_policy.arn
}

# Creating IAM Instance Profile
resource "aws_iam_instance_profile" "profile" {
  role = aws_iam_role.ec2_role.name
}

# Creating EC2 Instances in Different Subnets
resource "aws_instance" "instance_1" {
  ami                    = var.ami-id
  instance_type          = var.instance-type
  vpc_security_group_ids = [aws_security_group.SG.id]
  subnet_id              = aws_subnet.subnet1.id
  user_data              = base64encode(file("userdata1.sh"))
  iam_instance_profile   = aws_iam_instance_profile.profile.name
  connection {
    type = "ssh"
    user = "ubuntu"
    host = self.public_ip
    private_key = file("~/.ssh/rsa_id")
  }
  provisioner "remote-exec" {
    inline = [ 
        "sudo apt update -y",
        "sudo apt install docker.io -y",
        "sudo systemctl enable docker",
        "sudo systemctl start docker ",
        "sudo docker pull sumanthreddy1242/intrusion-detection",
        "sudo docker run -d -p 5000:5000 sumanthreddy1242/intrusion-detection:lates"
     ]
  }
}

resource "aws_instance" "instance_2" {
  ami                    = var.ami-id
  instance_type          = var.instance-type
  vpc_security_group_ids = [aws_security_group.SG.id]
  subnet_id              = aws_subnet.subnet2.id
  user_data              = base64encode(file("userdata2.sh"))
  iam_instance_profile   = aws_iam_instance_profile.profile.name

  connection {
    type = "ssh"
    user = "ubuntu"
    host = self.public_ip
    private_key = file("~/.ssh/rsa_id.pub")
  }
  provisioner "remote-exec" {
    inline = [ 
        "sudo apt update -y",
        "sudo apt install docker.io",
        "sudo systemctl enable docker",
        "sudo systemctl start docker",
        "sudo docker pull sumanthreddy1242/intrusion-detection",
        "sudo docker run -d -p 5000: sumanthreddy1242/intrusion-detection:lates"
     ]
  }
}

# Creating S3 Bucket
resource "aws_s3_bucket" "s3_bucket" {
  bucket = "sumanthreddydemo.com"
}

# Creating Load Balancer
resource "aws_lb" "LB" {
  name               = "Application-load"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.SG.id]
  subnets            = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
}

# Creating Load Balancer Target Group
resource "aws_lb_target_group" "Target" {
  name     = "Target-Group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.VPC.id

  health_check {
    path = "/"
    port = "traffic-port"
  }
}

# Attaching Instances to Target Group
resource "aws_lb_target_group_attachment" "attach1" {
  target_group_arn = aws_lb_target_group.Target.arn
  target_id        = aws_instance.instance_1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attach2" {
  target_group_arn = aws_lb_target_group.Target.arn
  target_id        = aws_instance.instance_2.id
  port             = 80
}

# Creating Load Balancer Listener
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.LB.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.Target.arn
    type             = "forward"
  }
}

# Output Load Balancer DNS Name
output "loadbalancerdns" {
  value = aws_lb.LB.dns_name
}
