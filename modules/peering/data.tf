data "aws_subnet_ids" "vpc_subnets" {
  vpc_id = "${var.vpc_id}"
}

data "aws_route_table" "default_route_table" {
  vpc_id = "${var.vpc_id}"
}
