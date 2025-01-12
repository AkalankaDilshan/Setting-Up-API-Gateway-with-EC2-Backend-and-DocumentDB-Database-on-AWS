variable "vpc_name" {
  type        = string
  description = "name for the VPC"
}

variable "cidr_block" {
  type        = string
  description = "CIDR ADDRESS for vpc"
}

variable "availability_zones" {
  type        = string
  description = "availability_zones list"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "cidr values for public subnet"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "cidr value for private subnet"
}
