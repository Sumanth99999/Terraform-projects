resource "aws_security_group" "rule" {
  vpc_id = module.VPC.vpc_id
}

resource "aws_security_group_rule" "Incoming" {
  description = "Allow ssh"
  from_port = "22"
  to_port = "22"
  protocol = "ssh"
  type = "ingress"
  security_group_id = aws_security_group.rule.id
  cidr_blocks = ["0.0.0.0/0"]

}

resource "aws_security_group_rule" "Traffic" {
  description = "Allow traffic for port 5000"
  type = "ingress"
  from_port = 5000
  to_port = "5000"
  protocol = "HTTP"
  security_group_id = aws_security_group.rule.id
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "outgoung" {
  description = "Outbound traffic"
  type = "egress"
  from_port = "0"
  to_port = "0"
  protocol = "-1"
  security_group_id = aws_security_group.rule.id
  cidr_blocks = ["0.0.0.0/0"]
}