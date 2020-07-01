variable "project" {}
variable "environment" {}
variable "profile" {}
variable "region" {}

variable "instance_class" {}
variable "allocated_storage" {}
variable "master_username" {}
variable "master_password" {}
variable "backup_window" {}
variable "engine" {}
variable "engine_version" {}
variable "storage_type" {}

variable "availability_zone" {}

variable "auto_minor_version_upgrade" {}
variable "database_port" {}
variable "allow_major_version_upgrade" {}
variable "copy_tags_to_snapshot" {}

variable "vpc_security_group_ids" {
  default = []
}

variable "apply_immediately" {}

variable "publicly_accessible" {
  default = false
}

variable "multi_az" {
  default = false
}

variable "maintenance_window" {}
variable "database_name" {}
variable "backup_retention_period" {}

variable "public_subnet_ids" {
  default = []
}

variable "skip_final_snapshot" {}
