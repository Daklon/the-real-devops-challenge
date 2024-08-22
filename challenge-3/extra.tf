
resource "aws_ec2_instance_connect_endpoint" "main" {
  subnet_id = aws_subnet.private["a"].id
}