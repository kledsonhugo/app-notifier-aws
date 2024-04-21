resource "aws_security_group" "vpc_sg_priv" {
  vpc_id = var.vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [var.vpc_cidr]
  }
}

resource "aws_db_subnet_group" "rds_sn_group" {
  name       = var.rds_sn_group_name
  subnet_ids = [var.vpc_sn_priv_az1_id, var.vpc_sn_priv_az2_id]
}

resource "aws_db_parameter_group" "rds_param_group" {
  name   = var.rds_param_group_name
  family = var.rds_family
  parameter {
    name  = "character_set_server"
    value = "utf8"
  }
  parameter {
    name  = "character_set_database"
    value = "utf8"
  }
}

resource "aws_db_instance" "rds_dbinstance" {
  identifier             = var.rds_identifier
  engine                 = var.rds_engine
  engine_version         = var.rds_engine_version
  instance_class         = var.rds_instance_class
  storage_type           = "gp2"
  allocated_storage      = 20
  max_allocated_storage  = 0
  monitoring_interval    = 0
  db_name                = var.rds_dbname
  username               = var.rds_dbuser
  password               = var.rds_dbpassword
  skip_final_snapshot    = true
  multi_az               = var.rds_multi_az
  db_subnet_group_name   = aws_db_subnet_group.rds_sn_group.name
  parameter_group_name   = aws_db_parameter_group.rds_param_group.name
  vpc_security_group_ids = [aws_security_group.vpc_sg_priv.id]
}