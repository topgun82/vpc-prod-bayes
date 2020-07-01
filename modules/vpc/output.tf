output "assigned_vpc" {
  value = "${aws_vpc.assigned_vpc.id}"
}

output "public_subnets" {
  value = ["${aws_subnet.public_subnets.*.id}"]
}

output "rds_access_sec_group" {
  value = "${aws_security_group.rds_access.id}"
}

output "server_access_sec_group" {
  value = "${aws_security_group.server_access.id}"
}

output "bastion_access_sec_group" {
  value = "${aws_security_group.bastion_access.id}"
}
