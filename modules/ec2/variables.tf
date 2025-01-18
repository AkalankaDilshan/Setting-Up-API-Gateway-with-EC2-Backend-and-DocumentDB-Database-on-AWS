variable "instance_name" {
  type        = string
  description = "name for the EC2 instance"
}

variable "instance_type" {
  type        = string
  description = "type of EC2 instance"
}

variable "subnet_id" {
  type        = string
  description = "subnet id for EC2 instance"
}

variable "vpc_security_group_id" {
  type        = string
  description = "security group id for ec2 instance"
}

variable "ebs_volume_type" {
  type        = string
  description = "type of instance value"
  default     = "gp2"
}

variable "ebs_volume_size" {
  type        = number
  description = "size of instance value"
  default     = 8
}

# variable "key_pair_name" {
#   type        = string
#   description = "name for ec2 ssh instance key pair"
# }
