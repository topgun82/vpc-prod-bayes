resource "aws_vpc_peering_connection" "bastion_to_server_peer" {
  auto_accept = true

  peer_vpc_id = "${var.peer_vpc_id}"
  vpc_id      = "${var.vpc_id}"

  tags = {
    Name        = "${var.project}-${var.environment}-bastion-to-scala"
    Environment = "${var.environment}"
  }

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_default_route_table" "private_route_table" {
  default_route_table_id = "${data.aws_route_table.default_route_table.id}"

  route {
    cidr_block                = "${var.vpc_bastion_cidr}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.bastion_to_server_peer.id}"
  }

  tags {
    Name        = "${var.project}-${var.environment}-private-route-table"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table_association" "private_rta" {
  count = "${length(data.aws_subnet_ids.vpc_subnets.ids)}"

  subnet_id      = "${element(data.aws_subnet_ids.vpc_subnets.ids, count.index)}"
  route_table_id = "${aws_default_route_table.private_route_table.id}"

  depends_on = ["aws_default_route_table.private_route_table"]
}
