variable "region" {
  type        = string
  default     = "us-east-1"
  description = "Enter the region in which Infra will created"
}

variable "vpc_name" {
  type        = string
  default     = "Cassandra_vpc"
  description = "Enter the VPC name"
}
variable "vpc_cidr" {
  type        = string
  default     = "12.0.0.0/16"
  description = "Enter the vpc cidr"
}

variable "bastion_sg_name" {
  type        = string
  default     = "Cassandra-bastion-sg"
  description = "Enter the security group name for bastion"
}

variable "enable_nat_gateway" {
  type        = bool
  default     = true
  description = "Enter the value for NAT true/false"
}
variable "az" {
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
  description = "Enter the Availability Zones"
}
variable "private_subnets" {
  type        = list(string)
  default     = ["12.0.1.0/24", "12.0.2.0/24", "12.0.3.0/24"]
  description = "Enter the private subnets cidr"
}

variable "public_subnets" {
  type        = list(string)
  default     = ["12.0.101.0/24"]
  description = "Enter the public subnet cidr"
}

variable "public_ec2_type" {
  type        = string
  default     = "t2.micro"
  description = "Enter the public ec2 types"
}
variable "public_key_name" {
  type        = string
  default     = "my-verginia"
  description = "Enter the public instance key name"
}

variable "private_key_name" {
  type        = string
  default     = "my-verginia"
  description = "Enter the private instance key name"
}
variable "private_ec2_type" {
  type        = string
  default     = "t2.large"
  description = "Enter the private ec2 types"
}

variable "ami_id" {
  type        = string
  default     = "ami-09e67e426f25ce0d7"
  description = "Enter the ami_id"
}

variable "default_tags" {
  type        = map(any)
  default     = { ENV = "Database", Owner = "Abhishek", company = "Opstree" }
  description = "Enter the tags"
}

variable "public_instance_name" {
  type        = string
  default     = "Cassandra-Bastion"
  description = "Enter the bastion name"
}
variable "private_instance_name" {
  type        = string
  default     = "seednode"
  description = "Enter the bastion name"
}

variable "private_sg_name" {
  type        = string
  default     = "Cassandra-private-sg"
  description = "Enter the private security group name"
}
locals {
  ip = data.http.ip
}
# 
# variable "ingress_with_cidr_blocks" {
# type        = list(any)
# default     = [{ from_port = 22, to_port = 22, protocol = "tcp", description = "Public Access", cidr_blocks = "0.0.0.0/0" }]
# description = "Enter the ports and cidrs you want to open"
# }


variable "ingress_with_cidr_blocks_database" {
  type        = list(any)
  default     = [{ from_port = 22, to_port = 22, protocol = "tcp", description = "By Bastion Access", cidr_blocks = "12.0.101.0/24" }]
  description = "Enter the ports and cidrs you want to open"
}