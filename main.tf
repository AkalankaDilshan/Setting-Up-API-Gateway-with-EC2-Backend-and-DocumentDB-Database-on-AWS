provider "aws" {
  region = "eu-north-1"
}

module "main_vpc" {
  source               = "./modules/vpc"
  vpc_name             = "Server-VPC"
  cidr_block           = "10.10.0.0/16"
  availability_zones   = ["eu-north-1a"]
  public_subnet_cidrs  = ["10.10.1.0/24"]
  private_subnet_cidrs = ["10.10.3.0/24"]
}

module "ec2_security_group" {
  source          = "./modules/security_group_ec2"
  sg_name         = "server-sg"
  vpc_id          = module.main_vpc.vpc_id
  nat_gateway_eip = flatten([module.main_vpc.nat_gateway_eip])
}

module "key_pair" {
  source = "./modules/key-pair-ssh"
}

module "server_instance" {
  source                = "./modules/ec2"
  instance_name         = "server-instance"
  instance_type         = "t3.micro"
  subnet_id             = module.main_vpc.private_subnet_id[0]
  vpc_security_group_id = module.ec2_security_group.ec2_sg_id
  ebs_volume_size       = 8
  ebs_volume_type       = "gp2"
  key_pair_name         = module.key_pair.key_pair_name
  depends_on            = [module.ec2_security_group, module.key_pair]
}
