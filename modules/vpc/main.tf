locals {
  region_azs = ["${var.region}a", "${var.region}b", "${var.region}c"]
}

resource "aws_vpc" "assigned_vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_support   = "${var.enable_dns_support}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"

  tags {
    Name        = "${var.project}-${var.environment}-${var.vpc_name}"
    Environment = "${var.environment}"
  }
}

resource "aws_subnet" "public_subnets" {
  vpc_id = "${aws_vpc.assigned_vpc.id}"

  count             = "${length(var.public_subnet_cidrs)}"
  cidr_block        = "${element(var.public_subnet_cidrs, count.index)}"
  availability_zone = "${element(local.region_azs, count.index)}"

  tags {
    Name        = "${var.project}-${var.environment}-${var.vpc_name}-public-${element(local.region_azs, count.index)}"
    Environment = "${var.environment}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.assigned_vpc.id}"

  tags {
    Name        = "${var.project}-${var.environment}-${var.vpc_name}-internet-gw"
    Environment = "${var.environment}"
  }
}

resource "aws_default_route_table" "public_route_table" {
  default_route_table_id = "${data.aws_route_table.default_route_table.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name        = "${var.project}-${var.environment}-${var.vpc_name}-public-route-table"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table_association" "public_rta" {
  count = "${length(var.public_subnet_cidrs)}"

  subnet_id      = "${element(aws_subnet.public_subnets.*.id, count.index)}"
  route_table_id = "${aws_default_route_table.public_route_table.id}"
}

resource "aws_security_group" "server_access" {
  vpc_id = "${aws_vpc.assigned_vpc.id}"
  name   = "${var.project}-${var.environment}-scala-server-access"

  tags {
    Name        = "${var.project}-${var.environment}-${var.vpc_name}-server-access-sec-group"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "bastion_access" {
  vpc_id = "${aws_vpc.assigned_vpc.id}"
  name   = "${var.project}-${var.environment}-${var.vpc_name}-bastion-access"

  tags {
    Name        = "${var.project}-${var.environment}-${var.vpc_name}-bastion-access-sec-group"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "rds_access" {
  vpc_id = "${aws_vpc.assigned_vpc.id}"
  name   = "${var.project}-${var.environment}-${var.vpc_name}-rds-access"

  tags {
    Name        = "${var.project}-${var.environment}-${var.vpc_name}-rds-sec-group"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group_rule" "sec_group_db" {
  count             = "${var.create_db_sec_group != "" ? 1 : 0}"
  security_group_id = "${aws_security_group.rds_access.id}"

  type        = "ingress"
  from_port   = 5432
  to_port     = 5432
  protocol    = "6"
  cidr_blocks = ["${var.vpc_cidr}"]
}

resource "aws_security_group_rule" "server_https_ingress" {
  count             = "${var.create_ingress_sec_group != "" ? 1 : 0}"
  security_group_id = "${aws_security_group.server_access.id}"

  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "6"

  // this is used by the scala content manager to server videos.
  // this should be open to the entire internet at all times.
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "server_remote_desktop_ingress" {
  count             = "${var.create_rmd_server != "" ? 1 : 0}"
  security_group_id = "${aws_security_group.server_access.id}"

  // this is the remote desktop client port, this should be whitelisted
  type = "ingress"

  from_port = 3389
  to_port   = 3389
  protocol  = "6"

  cidr_blocks = ["${var.bastion_vpc_cidr}"]
}

resource "aws_security_group_rule" "server_egress_all" {
  count             = "${var.create_ingress_sec_group != "" ? 1 : 0}"
  security_group_id = "${aws_security_group.server_access.id}"

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "bastion_remote_desktop_ingress" {
  count             = "${var.create_mrd_sec_group != "" ? 1 : 0}"
  security_group_id = "${aws_security_group.bastion_access.id}"

  // this is the remote desktop client port, this should be whitelisted
  type = "ingress"

  from_port = 3389
  to_port   = 3389
  protocol  = "6"

  cidr_blocks = ["${var.sg_whitelist}"]
}

resource "aws_security_group_rule" "bastion_egress_all" {
  count             = "${var.create_mrd_sec_group != "" ? 1 : 0}"
  security_group_id = "${aws_security_group.bastion_access.id}"

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
