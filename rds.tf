resource "aws_db_instance" "rds_instance" {
  identifier             = var.rds_identifier
  engine                 = var.rds_engine
  engine_version         = var.rds_engine_version
  instance_class         = var.rds_instance_class
  allocated_storage      = var.rds_storage
  storage_type           = var.rds_storage_type
  vpc_security_group_ids = [aws_security_group.main-sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  db_name                = var.rds_db_name
  username               = var.rds_username
  password               = var.rds_password
  skip_final_snapshot    = var.skip_snapshot
}


resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = var.rds_subnet_name
  subnet_ids = [aws_subnet.private[4].id, aws_subnet.private[3].id]

  tags = {
    Name = var.rds_subnet_name
  }
}
