variable "project" {}
variable "environment" {}
variable "profile" {}
variable "region" {}

variable "vpc_cidr" {}

variable "vpc_name" {}

variable "public_subnet_cidrs" {
  default = []
}

variable "sg_whitelist_scala" {
  default = []
}

variable "sg_whitelist" {
  default     = []
  description = "Generic list that includes all CIDRs that need to be added to the whitelst within a module"
}

variable "enable_dns_support" {}

variable "map_public_ip_on_launch" {}

variable "enable_dns_hostnames" {}

variable "create_ingress_sec_group" {
  default = ""
}

variable "create_rds_sec_group" {
  default = ""
}

variable "create_db_sec_group" {
  default = ""
}

variable "create_mrd_sec_group" {
  default = ""
}

variable "bastion_vpc_cidr" {}

variable "create_rmd_server" {
  default = ""
}
