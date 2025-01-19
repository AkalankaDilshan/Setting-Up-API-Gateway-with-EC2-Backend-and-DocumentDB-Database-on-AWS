data "aws_ami" "latest_ami" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "image-id"
    values = ["ami-09423ec3aa48e9438"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_instance" "server_instance" {
  ami                         = data.aws_ami.latest_ami.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.vpc_security_group_id]
  user_data                   = templatefile("${path.module}/init-script.sh", {})
  associate_public_ip_address = false
  disable_api_termination     = false
  ebs_optimized               = false
  root_block_device {
    volume_type = var.ebs_volume_type
    volume_size = var.ebs_volume_size
    encrypted   = true
  }

  # key_name = var.key_pair_name

  tags = {
    Name = var.instance_name
  }
}
