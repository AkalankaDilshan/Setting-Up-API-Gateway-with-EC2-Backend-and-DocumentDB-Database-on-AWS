resource "aws_security_group" "load_balancer_security_group" {
  name        = var.sg_name
  description = "allow HTTP request from any source"
  vpc_id      = var.vpc_id
  tags = {
    Name = var.sg_name
  }
}
