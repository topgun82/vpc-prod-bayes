output "windows_instance" {
  value = "${aws_instance.windows2012r2.public_ip}"
}
