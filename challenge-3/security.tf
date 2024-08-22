resource "aws_security_group" "load_balancer" {
  name        = "load_balancer"
  description = "Security group for the load balancer"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "load_balancer"
  }
}

resource "aws_security_group_rule" "lb_allow_http_ipv4_ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.load_balancer.id
}

resource "aws_security_group_rule" "lb_allow_http_ipv4_egress" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = aws_security_group.autoscaling_group.id
  security_group_id = aws_security_group.load_balancer.id
}

resource "aws_security_group" "autoscaling_group" {
  name        = "autoscaling_group"
  description = "Security group for the autoscaling group"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "autoscaling_group"
  }
}

resource "aws_security_group_rule" "asg_allow_http_ipv4_ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = aws_security_group.load_balancer.id
  security_group_id = aws_security_group.autoscaling_group.id
}

resource "aws_security_group_rule" "asg_allow_http_ipv4_egress" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.autoscaling_group.id
}

resource "aws_security_group_rule" "asg_allow_https_ipv4_egress" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.autoscaling_group.id
}

resource "aws_security_group_rule" "asg_allow_ssh_ipv4_egress" {
  type              = "egress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = aws_vpc.main.default_security_group_id
  security_group_id = aws_security_group.autoscaling_group.id
}

resource "aws_security_group_rule" "asg_allow_ssh_ipv4_ingress" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.autoscaling_group.id
}

resource "aws_security_group_rule" "asg_allow_postgres_ipv4_egress" {
  type              = "egress"
  from_port         = aws_rds_cluster.main.port
  to_port           = aws_rds_cluster.main.port
  protocol          = "tcp"
  source_security_group_id = aws_security_group.rds.id
  security_group_id = aws_security_group.autoscaling_group.id
}

resource "aws_security_group_rule" "asg_allow_postgres_ipv4_ingress" {
  type              = "ingress"
  from_port         = aws_rds_cluster.main.port
  to_port           = aws_rds_cluster.main.port
  protocol          = "tcp"
  source_security_group_id = aws_security_group.rds.id
  security_group_id = aws_security_group.autoscaling_group.id
}

resource "aws_security_group" "rds" {
  name        = "RDS"
  description = "Security group for the rds cluster"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "RDS"
  }
}

resource "aws_security_group_rule" "rds_allow_postgres_ipv4_ingress" {
  type              = "ingress"
  from_port         = aws_rds_cluster.main.port
  to_port           = aws_rds_cluster.main.port
  protocol          = "tcp"
  source_security_group_id = aws_security_group.autoscaling_group.id
  security_group_id = aws_security_group.rds.id
}

resource "aws_security_group_rule" "rds_allow_postgres_ipv4_egress" {
  type              = "egress"
  from_port         = aws_rds_cluster.main.port
  to_port           = aws_rds_cluster.main.port
  protocol          = "tcp"
  source_security_group_id = aws_security_group.autoscaling_group.id
  security_group_id = aws_security_group.rds.id
}