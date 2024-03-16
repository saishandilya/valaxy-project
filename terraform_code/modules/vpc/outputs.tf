output "vpc-id" {
  value = aws_vpc.devops-vpc.id
}

output "vpc-pub1-subnet" {
  value = aws_subnet.public-subnet1.id
}

output "vpc-pub2-subnet" {
  value = aws_subnet.public-subnet2.id
}

output "vpc-sg-id" {
  value = aws_security_group.devops-vpc-sg.id
}