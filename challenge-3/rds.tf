resource "aws_db_subnet_group" "main" {
  name       = "mysql_subnet_group"
  subnet_ids = [for subnet in aws_subnet.private : subnet.id]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_rds_cluster" "main" {
  cluster_identifier          = "challenge-3"
  availability_zones          = [for subnet in var.subnets.private : subnet.az]
  engine                      = "postgres"
  engine_mode                 = "provisioned"
  engine_version              = var.rds_engine_version
  db_cluster_instance_class   = var.rds_instance_class
  db_subnet_group_name        = aws_db_subnet_group.main.id
  storage_type                = "io1"
  allocated_storage           = var.rds_allocated_storage
  iops                        = 1000
  master_username             = var.rds_master_username
  manage_master_user_password = true
  skip_final_snapshot         = true
  vpc_security_group_ids = [aws_security_group.rds.id]

  serverlessv2_scaling_configuration {
    max_capacity = 1.0
    min_capacity = 0.5
  }
}