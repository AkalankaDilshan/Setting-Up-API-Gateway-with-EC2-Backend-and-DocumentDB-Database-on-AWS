resource "aws_lb" "application_load_balancer" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = var.load_balancer_type
  security_groups    = [var.security_group_id]
  subnets            = var.alb_subnet_ids

  # enable_deletion_protection = var.enable_deletion_protection
  tags = {
    Name = var.alb_name
  }
}
resource "aws_lb_target_group" "app_tg" {
  name     = "${var.alb_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  # target_type = "ip"
  health_check {
    path                = var.health_check_path
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    protocol            = "HTTP"
  }

  tags = {
    Name = "${var.alb_name}-tg"
  }
}

resource "aws_lb_target_group_attachment" "alb_tg_attachment" {
  # for_each         = { for idx, id in var.targets_ids : idx => id }
  count            = length(var.targets_ids)
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = var.targets_ids[count.index]
  # target_id        = each.value
  port = 80
}

resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
