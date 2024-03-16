output "ansible-server" {
  value = module.ec2_instance.ansible-public-ip
}

output "jenkins-master" {
  value = module.ec2_instance.jenkins-master-public-ip
}

output "jenkins-slave" {
  value = module.ec2_instance.jenkins-slave-public-ip
}

output "vpcid" {
  value = module.vpc.vpc-id
}

output "vpcpub1-subnet" {
  value = module.vpc.vpc-pub1-subnet
}

output "vpcpub2-subnet" {
  value = module.vpc.vpc-pub2-subnet
}

output "vpcsg-id" {
  value = module.vpc.vpc-sg-id
}