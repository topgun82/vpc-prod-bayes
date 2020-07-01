variable "project" {}
variable "environment" {}
variable "profile" {}
variable "region" {}

variable "ami_id" {}
variable "disable_api_termination" {}

variable "vpc_security_group_ids" {
  default = []
}

variable "ami_role" {}

variable "default_subnet_id" {}
variable "instance_type" {}

variable "key_pair_name" {}

variable "associate_public_ip_address" {}

variable "create_additional_ebs_volume" {
  default = "false"
}

variable "root_ebs_volume_size" {}

variable "additional_ebs_volume_size" {}
