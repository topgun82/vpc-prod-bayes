variable "project" {}
variable "environment" {}
variable "profile" {}
variable "region" {}

variable "vpc_cidr" {}

variable "vpc_name" {}

variable "ami_role" {}

variable "associate_public_ip_address" {}
variable "server_key_pair" {}

variable "public_subnet_cidrs" {
  default = []
}

variable "create_additional_ebs_volume" {
  default = false
}

variable "root_ebs_volume_size" {}

variable "additional_ebs_volume_size" {}

variable "bastion_vpc_cidr" {}

variable "sg_whitelist_grp1" {
  default     = []
  description = "This whitelist includes IPs from other peers (Vendors, collaborators, etc.) "
}

variable "sg_whitelist_grp2" {
  default     = []
  description = "This whitelists the CIDR blocks used by office"
}

variable "sg_whitelist" {
  default     = []
  description = "Generic list that includes all CIDRs that need to be added to the whitelst within a module"
}

variable "map_public_ip_on_launch" {
  default = "false"
}

variable "enable_dns_support" {
  default = "false"
}

variable "enable_dns_hostnames" {
  default = "false"
}

variable "public_subnets_ids" {
  default = []
}

variable "db_name" {}
variable "db_allocated_storage" {}
variable "db_username" {}
variable "db_password" {}
variable "db_retention_period" {}
variable "db_backup_window" {}
variable "db_engine" {}

variable "db_port" {
  default = "5432"
}

variable "db_engine_version" {}
variable "db_instance_class" {}
variable "db_storage_type" {}

variable "db_apply_immediately" {
  default = false
}

variable "db_skip_final_snapshot" {
  default = false
}

variable "db_publicly_accessible" {
  default = false
}

variable "db_vpc_security_group_ids" {
  default = []
}

variable "db_copy_tags_to_snapshot" {
  default = false
}

variable "db_auto_minor_version_upgrade" {
  default = true
}

variable "db_multi_az" {
  default = false
}

variable "db_allow_major_version_upgrade" {
  default = true
}

variable "db_maintenance_window" {}

// AMI variables

variable "ami_id" {}

variable "disable_api_termination" {
  default = "false"
}

variable "instance_type" {}
