output "ansible-public-ip" {
  value = aws_instance.ansible.public_ip
}

output "jenkins-master-public-ip" {
  value = aws_instance.jenkins-master.public_ip
}

output "jenkins-slave-public-ip" {
  value = aws_instance.jenkins-slave.public_ip
}