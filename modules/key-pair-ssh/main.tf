resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_key_pair_ssh" {
  key_name   = "ec2_key_pair_ssh"
  public_key = tls_private_key.ssh_key.public_key_openssh
}
