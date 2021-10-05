output "vpc" {
  value = module.vpc.vpc_id
}


output "Cassandra-bastion-security-group" {
  value = module.Cassandra-bastion-security-group
}

output "Cassandra-private-security-group" {
  value = module.Cassandra-private-security-group
}

output "ec2_instance_private" {
  value = module.ec2_instance_private
}

output "ec2_instance_public_ip" {
  value = module.ec2_instance_public
}

output "ip" {
  value = data.http.ip.body
}
