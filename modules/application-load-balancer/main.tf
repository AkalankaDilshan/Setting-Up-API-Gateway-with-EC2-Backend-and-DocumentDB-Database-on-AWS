resource "aws_lb" "application_load_balancer" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = var.load_balancer_type
  security_groups    = [var.security_group_id]
  subnets            = var.alb_subnet_ids

  enable_deletion_protection = var.enable_deletion_protection
  tags = {
    Name = var.alb_name
  }

}
