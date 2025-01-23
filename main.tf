provider "aws" {
  region = "eu-north-1"
}

module "main_vpc" {
  source               = "./modules/vpc"
  vpc_name             = "Server-VPC"
  cidr_block           = "10.10.0.0/16"
  availability_zones   = ["eu-north-1a", "eu-north-1b"]
  public_subnet_cidrs  = ["10.10.1.0/24", "10.10.2.0/24"]
  private_subnet_cidrs = ["10.10.3.0/24", "10.10.4.0/24"]
}

module "lb_security_group" {
  source  = "./modules/security_group_lb"
  sg_name = "lb-sg"
  vpc_id  = module.main_vpc.vpc_id
}
module "ec2_security_group" {
  source                          = "./modules/security_group_ec2"
  sg_name                         = "server-sg"
  vpc_id                          = module.main_vpc.vpc_id
  nat_gateway_eip                 = flatten([module.main_vpc.nat_gateway_eip])
  load_balancer_security_group_id = module.lb_security_group.lb_sg_id
  depends_on                      = [module.lb_security_group]
}

module "key_pair" {
  source = "./modules/key-pair-ssh"
}

module "private_ec2" {
  source                = "./modules/ec2"
  instance_name         = "private-ec2"
  instance_type         = "t3.micro"
  count                 = length(module.main_vpc.private_subnet_id)
  subnet_id             = module.main_vpc.private_subnet_id[count.index]
  vpc_security_group_id = module.ec2_security_group.ec2_sg_id
  ebs_volume_size       = 8
  ebs_volume_type       = "gp2"
  key_pair_name         = module.key_pair.key_pair_name
  depends_on            = [module.ec2_security_group, module.key_pair]
}


module "load_balancer" {
  source             = "./modules/application-load-balancer"
  count              = length(module.private_ec2.instance_id)
  alb_name           = "app-lb"
  load_balancer_type = "application"
  vpc_id             = module.main_vpc.vpc_id
  alb_subnet_ids     = flatten(module.main_vpc.public_subnet_id)
  target_group_type  = "instance"
  target_id          = module.private_ec2.instance_id[count.index]
  security_group_id  = module.lb_security_group.lb_sg_id
  depends_on         = [module.lb_security_group, module.private_ec2]
}
