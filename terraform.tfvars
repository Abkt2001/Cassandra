region                = "us-east-1"
vpc_name              = "cassandra_vpc"
vpc_cidr              = "12.0.0.0/16"
az                    = ["us-east-1a", "us-east-1b", "us-east-1c"]
private_subnets       = ["12.0.1.0/24", "12.0.2.0/24", "12.0.3.0/24"]
public_subnets        = ["12.0.101.0/24"]
enable_nat_gateway    = true
public_ec2_type       = "t2.large"
public_key_name       = "my-verginia"
private_key_name      = "my-verginia"
private_ec2_type      = "t2.large"
ami_id                = "ami-09e67e426f25ce0d7"
default_tags          = { ENV = "Cassandra", Version = "311x", Company = "Opstree", Owner = "Abhishek" }
public_instance_name  = "Cassandra-bastion"
profile_name          = "ec2-ansible"
private_instance_name = "seednode"
bastion_sg_name       = "Cassandra-bastion-sg"
private_sg_name       = "Cassandra-private-sg"
# ingress_with_cidr_blocks = [{ from_port = 7070, to_port = 7070, protocol = "tcp", description = "JMX Exporter ports", cidr_blocks = "0.0.0.0/0" }]
ingress_with_cidr_blocks_database = [{ from_port = 7000, to_port = 7000, protocol = "tcp", description = "Cluster communication", cidr_blocks = "0.0.0.0/0" },
  { from_port = 7070, to_port = 7070, protocol = "tcp", description = "JMX Exporter", cidr_blocks = "0.0.0.0/0" },
{ from_port = 9042, to_port = 9042, protocol = "tcp", description = "Cassandra-clients", cidr_blocks = "12.0.0.0/16" }]