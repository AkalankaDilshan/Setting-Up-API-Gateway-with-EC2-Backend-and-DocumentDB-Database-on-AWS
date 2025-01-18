variable "vpc_id" {
  type        = string
  description = "main vpc id"
}

variable "alb_name" {
  type        = string
  description = "name for application load balancer"
}

variable "alb_subnet_ids" {
  type        = list(string)
  description = "subnet ids for stablize for alb"
}

variable "security_group_id" {
  type        = string
  description = "security group for application load balancer"
}

variable "health_check_path" {
  type        = string
  description = "path for health check"
  default     = "/"
}

variable "load_balancer_type" {
  type        = string
  description = "alb type like application,network etc"
}

variable "target_group_type" {
  type        = string
  description = "the type in target group like instance,ip,lambda"
}

variable "targets_ids" {
  type        = list(string)
  description = "list of target ids"
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for the ALB"
  type        = bool
  default     = false
}

