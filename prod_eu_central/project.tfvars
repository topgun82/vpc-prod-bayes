project = "project1"

region = "eu-central-1"

environment = "prod"

profile = "project1"

vpc_cidr = "172.18.0.0/18"

public_subnet_cidrs = [
  "172.18.0.0/20",
  "172.18.16.0/20",
  "172.18.32.0/20",
]

additional_ebs_volume_size = 1500

root_ebs_volume_size = 500

bastion_vpc_cidr = "172.15.0.0/18"

create_additional_ebs_volume = true

map_public_ip_on_launch = true

enable_dns_support = true

enable_dns_hostnames = true

associate_public_ip_address = true

server_key_pair = "project1-prod-server-key"

vpc_name = "server"

ami_role = "server"

sg_whitelist_grp1 = [
  "62.92.71.154/32",
]

sg_whitelist_grp2 = [
  "87.237.218.0/24",
  "87.237.219.0/24",
  "62.128.7.0/24",
  "87.191.157.111/32",
]

enable_dns_support = true

enable_dns_hostnames = true

db_publicly_accessible = false

// Data store related configuration

// RDS Vars

db_engine = "postgres"

db_engine_version = "9.6.9"

db_name = "scala_cm"

db_allocated_storage = 100

db_username = "tac"

db_instance_class = "db.t2.medium"

db_retention_period = 5

db_backup_window = "00:00-01:00"

db_apply_immediately = false

db_auto_minor_version_upgrade = false

allow_major_version_upgrade = false

db_copy_tags_to_snapshot = true

db_maintenance_window = "Tue:01:00-Tue:04:00"

db_multi_az = true

db_storage_type = "gp2"

db_skip_final_snapshot = false

// AMI variables

ami_id = "ami-f7ece81c"

instance_type = "m5.xlarge"
