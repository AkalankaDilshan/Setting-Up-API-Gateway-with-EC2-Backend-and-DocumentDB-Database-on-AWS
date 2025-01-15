variable "sg_name" {
  type        = string
  description = "name for security group for ec2"
}
variable "vpc_id" {
  type        = string
  description = "main vpc id"
}
variable "nat_gateway_eip" {
  type        = list(string)
  description = "NAT gateway Elastic IP addresses"
}
