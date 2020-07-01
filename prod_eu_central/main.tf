module "vpc" {
  source = "../modules/vpc"

  profile     = "${var.profile}"
  project     = "${var.project}"
  region      = "${var.region}"
  environment = "${var.environment}"
  vpc_name    = "${var.vpc_name}"

  bastion_vpc_cidr = "${var.bastion_vpc_cidr}"

  // this enables the VPC module to create additional security groups that
  // shouldn't be found in the bastion.

  // create the custom sec group rules
  // this means 443 access from anywhere
  // RDP only from bastion
  create_ingress_sec_group = "1"
  create_db_sec_group     = "1"
  create_mrd_sec_group    = "1"
  create_rmd_server       = "1"
  vpc_cidr                = "${var.vpc_cidr}"
  public_subnet_cidrs     = "${var.public_subnet_cidrs}"
  map_public_ip_on_launch = true
  enable_dns_support      = true
  enable_dns_hostnames    = true
  // TODO: whitelist incoming traffic from bastion vpc cidr.
  sg_whitelist = [
    "${var.bastion_vpc_cidr}",
  ]
}

module "server" {
  source = "../modules/ami"

  project       = "${var.project}"
  region        = "${var.region}"
  environment   = "${var.environment}"
  profile       = "${var.profile}"
  key_pair_name = "${var.server_key_pair}"
  ami_role      = "${var.ami_role}"

  root_ebs_volume_size = "${var.root_ebs_volume_size}"

  additional_ebs_volume_size = "${var.additional_ebs_volume_size}"

  ami_id                      = "${var.ami_id}"
  associate_public_ip_address = "${var.associate_public_ip_address}"

  vpc_security_group_ids = [
    "${module.vpc.server_access_sec_group}",
  ]

  disable_api_termination = "${var.disable_api_termination}"
  instance_type           = "${var.instance_type}"
  default_subnet_id       = "${module.vpc.public_subnets[0]}"
}

module "dns" {
  project     = "${var.project}"
  region      = "${var.region}"
  environment = "${var.environment}"
  profile     = "${var.profile}"

  source    = "../modules/dns"
  subdomain = "scala"

  machine_public_ip = "${module.server.windows_instance}"
}

module "rds" {
  source = "../modules/rds"

  project     = "${var.project}"
  region      = "${var.region}"
  environment = "${var.environment}"
  profile     = "${var.profile}"

  availability_zone   = "${var.region}a"
  public_subnet_ids   = "${module.vpc.public_subnets}"
  skip_final_snapshot = "${var.db_skip_final_snapshot}"

  engine                      = "${var.db_engine}"
  engine_version              = "${var.db_engine_version}"
  instance_class              = "${var.db_instance_class}"
  master_password             = "${var.db_password}"
  master_username             = "${var.db_username}"
  allocated_storage           = "${var.db_allocated_storage}"
  backup_retention_period     = "${var.db_retention_period}"
  backup_window               = "${var.db_backup_window}"
  database_port               = "${var.db_port}"
  database_name               = "${var.db_name}"
  apply_immediately           = "${var.db_apply_immediately}"
  publicly_accessible         = "${var.db_publicly_accessible}"
  copy_tags_to_snapshot       = "${var.db_copy_tags_to_snapshot}"
  auto_minor_version_upgrade  = "${var.db_auto_minor_version_upgrade}"
  allow_major_version_upgrade = "${var.allow_major_version_upgrade}"
  storage_type                = "${var.db_storage_type}"

  allow_major_version_upgrade = "${var.db_allow_major_version_upgrade}"
  maintenance_window          = "${var.db_maintenance_window}"
  multi_az                    = "${var.db_multi_az}"

  vpc_security_group_ids = [
    "${module.vpc.rds_access_sec_group}",
  ]
}
