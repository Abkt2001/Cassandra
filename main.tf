provider "aws" {
  region = var.region
  default_tags {
    tags = var.default_tags
  }

}


data "http" "ip" {
  url = "https://ifconfig.me"
}

module "vpc" {
  source             = "terraform-aws-modules/vpc/aws"
  name               = "cassandra-vpc"
  cidr               = var.vpc_cidr
  azs                = var.az
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  enable_nat_gateway = var.enable_nat_gateway
  # tags             = merge(var.default_tags, {Name=var.vpc_name})
}


module "Cassandra-bastion-security-group" {
  source              = "terraform-aws-modules/security-group/aws"
  name                = var.bastion_sg_name
  description         = "Security group for user-service with custom ports open within VPC"
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = [join("/", [data.http.ip.body, "32"])]
  ingress_rules       = ["ssh-tcp", ]
  egress_rules        = ["all-all"]
  # ingress_with_cidr_blocks = var.ingress_with_cidr_blocks
  # tags                = merge(var.default_tags, { Name = var.bastion_sg_name })
}

module "ec2_instance_public" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  count                  = length(module.vpc.public_subnets) 
  ami                    = var.ami_id                        #"ami-070a60b7fec87131f" 
  instance_type          = var.public_ec2_type
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.Cassandra-bastion-security-group.security_group_id]
  key_name               = var.public_key_name
  name                   = var.public_instance_name
  iam_instance_profile   = "ec2-ansible"

  # tags                 = merge(var.default_tags,{ Name = var.public_instance_name })
}


module "Cassandra-private-security-group" {
  source                   = "terraform-aws-modules/security-group/aws"
  vpc_id                   = module.vpc.vpc_id
  ingress_cidr_blocks      = var.public_subnets #[join("/", ["0.0.0.0", "0"])] 
  ingress_rules            = ["cassandra-thrift-clients-tcp", "cassandra-jmx-tcp", "ssh-tcp"]
  egress_rules             = ["all-all"]
  ingress_with_cidr_blocks = var.ingress_with_cidr_blocks_database
  name                     = var.private_sg_name
  # tags                     = merge(var.default_tags, { Name = var.private_sg_name })

}

module "ec2_instance_private" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  count                  = length(module.vpc.private_subnets) 
  ami                    = var.ami_id
  instance_type          = var.private_ec2_type
  subnet_id              = module.vpc.private_subnets[count.index]
  vpc_security_group_ids = [module.Cassandra-private-security-group.security_group_id]
  key_name               = var.private_key_name
  name                   = tostring(join("_", [var.private_instance_name, count.index]))

}



# This architecture includes ingress rules for TCP ports 7000, 7001, 7199, 9042, and 9160. 
# Apache Cassandra uses port 7000 for communication between clusters (or port 7001 if SSL is enabled) and
#  port 7199 for JMX. Port 9042 is the client port, and 9160 is the native transport port.
