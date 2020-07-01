resource "aws_db_instance" "mysql_instance" {
  name = "${var.project}-${var.environment}"

  identifier             = "${var.project}-${var.environment}"
  engine                 = "${var.engine}"
  engine_version         = "${var.engine_version}"
  instance_class         = "${var.instance_class}"
  allocated_storage      = "${var.allocated_storage}"
  multi_az               = "${var.multi_az}"
  storage_type           = "${var.storage_type}"
  skip_final_snapshot    = "${var.skip_final_snapshot}"
  name                   = "${var.database_name}"
  username               = "${var.master_username}"
  password               = "${var.master_password}"
  port                   = "${var.database_port}"
  vpc_security_group_ids = ["${var.vpc_security_group_ids}"]

  publicly_accessible         = "${var.publicly_accessible}"
  allow_major_version_upgrade = "${var.allow_major_version_upgrade}"
  auto_minor_version_upgrade  = "${var.auto_minor_version_upgrade}"
  apply_immediately           = "${var.apply_immediately}"
  maintenance_window          = "${var.maintenance_window}"
  copy_tags_to_snapshot       = "${var.copy_tags_to_snapshot}"
  backup_retention_period     = "${var.backup_retention_period}"
  backup_window               = "${var.backup_window}"
  db_subnet_group_name        = "${aws_db_subnet_group.db_subnet_group.id}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.project}-${var.environment}-db-sub-group"
  subnet_ids = ["${var.public_subnet_ids}"]

  tags {
    Name        = "${var.project}-${var.environment}-db-sub-group"
    Environment = "${var.environment}"
  }
}
