resource "aws_db_instance" "rds_db" {
  allocated_storage                 = var.allocated_storage
  max_allocated_storage             = var.max_allocated_storage
  engine                            = var.engine
  engine_version                    = var.engine_version
  instance_class                    = var.instance_class
  name                              = var.name
  username                          = "master"
  password                          = random_password.db_master_pass.result
  parameter_group_name              = aws_db_parameter_group.defaault.id
  skip_final_snapshot               = var.skip_final_snapshot
  enabled_cloudwatch_logs_exports   = var.enabled_cloudwatch_logs_exports
  db_subnet_group_name              = aws_db_subnet_group.subnet_group.id
  vpc_security_group_ids            = var.security_group_ids
  identifier                        = var.name

  tags = {
    Environment = var.environment
  }
}


resource "random_password" "db_master_pass" {
  length            = 40
  special           = true
  min_special       = 5
  override_special  = "!#$%^&*()-_=+[]{}<>:?"
  keepers           = {
    pass_version  = 1
  }
}


resource "aws_secretsmanager_secret" "db-pass" {
  name = "db-master-password-${var.name}-${var.environment}"
}


resource "aws_secretsmanager_secret_version" "db-pass-val" {
  secret_id     = aws_secretsmanager_secret.db-pass.id
  secret_string = random_password.db_master_pass.result
}


resource "aws_db_parameter_group" "default" {
  name   = "rds-${var.name}-pg"
  family = "mysql8.0"
}


resource "aws_db_subnet_group" "subnet_group" {
  name       = "${var.name}_db_subnet_group"
  subnet_ids = var.subnet_ids

  tags = {
    Environment = var.environment
  }
}