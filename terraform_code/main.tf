/*
provider "aws" {
    region = "us-east-1"
}
*/

module "vpc" {
    source = "./modules/vpc"
    vpc_cidr = var.vpccidr
    vpc_pub1_sub_cidr = var.vpcpub1subcidr
    vpc_pub2_sub_cidr = var.vpcpub2subcidr
    vpc_sg_cidr_blocks = var.vpcsgcidrblocks
}

module "ec2_instance" {
    source = "./modules/ec2_instance"
    ami_value = var.ami
    instance_type_value = var.instancetype
    key_name_value = var.keyname
    subnet_id_value = module.vpc.vpc-pub1-subnet
    security_group_value = module.vpc.vpc-sg-id
}