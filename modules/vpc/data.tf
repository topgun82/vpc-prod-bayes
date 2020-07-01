data "aws_route_table" "default_route_table" {
  vpc_id = "${aws_vpc.assigned_vpc.id}"
}
