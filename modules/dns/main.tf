resource "aws_route53_record" "www" {
  zone_id = "${data.aws_route53_zone.disip_fqdn.zone_id}"
  name    = "${var.subdomain}.${data.aws_route53_zone.disip_fqdn.name}"
  type    = "A"
  ttl     = "300"
  records = ["${var.machine_public_ip}"]
}
