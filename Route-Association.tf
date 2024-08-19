resource "aws_route_table_association" "A1" {
  subnet_id = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.routetable.id
}
resource "aws_route_table_association" "A2" {
  subnet_id = aws_subnet.subnet-2.id
  route_table_id = aws_route_table.routetable.id
}