resource "aws_security_group" "rule" {
  vpc_id = module.VPC.vpc_id
}

resource "aws_security_group_rule" "Incoming" {
  description = "Allow ssh"
  from_port = "0"
  to_port = "0"
  protocol = "-1"
  type = "ingress"
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