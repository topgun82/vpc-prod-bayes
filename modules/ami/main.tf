resource "aws_instance" "windows2012r2" {
  ami                         = "${var.ami_id}"
  associate_public_ip_address = "${var.associate_public_ip_address}"

  key_name                = "${var.key_pair_name}"
  disable_api_termination = "${var.disable_api_termination}"
  instance_type           = "${var.instance_type}"

  vpc_security_group_ids = ["${var.vpc_security_group_ids}"]

  subnet_id = "${var.default_subnet_id}"

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "${var.root_ebs_volume_size}"
    delete_on_termination = false
  }

  tags {
    Name        = "${var.project}-${var.environment}-${var.ami_role}-windows-server-2012r2"
    Environment = "${var.environment}"
  }
}

resource "aws_ebs_volume" "additional_ebs_volume" {
  count             = "${var.create_additional_ebs_volume != "" ? 1 : 0}"
  availability_zone = "${var.region}a"

  size = "${var.additional_ebs_volume_size}"
  type = "gp2"

  tags {
    Name        = "${var.project}-${var.environment}-additional-ebs-${var.ami_role}"
    Environment = "${var.environment}"
  }
}

resource "aws_volume_attachment" "ebs_attachment_additional" {
  count = "${var.create_additional_ebs_volume != "" ? 1 : 0}"

  device_name = "xvdah"
  volume_id   = "${aws_ebs_volume.additional_ebs_volume.id}"
  instance_id = "${aws_instance.windows2012r2.id}"
}
