output "alb_dns_name" {
  description = "the DNS name for the ALB"
  value       = aws_lb.application_load_balancer.dns_name
}
