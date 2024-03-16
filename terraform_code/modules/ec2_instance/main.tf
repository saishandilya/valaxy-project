provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "ansible" {
  ami                    = var.ami_value
  instance_type          = var.instance_type_value
  key_name               = var.key_name_value
  vpc_security_group_ids = [var.security_group_value]
  subnet_id              = var.subnet_id_value

  tags = {
    Name = "ansible"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("keys/${var.key_name_value}.pem") # Place your key in this folder which you have created
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "keys/${var.key_name_value}.pem" # Place your key in this folder which you have created
    destination = "/home/ubuntu/${var.key_name_value}.pem"
  }

  provisioner "file" {
    source = "files/jenkins-master-setup.yaml"
    destination = "/home/ubuntu/jenkins-master-setup.yaml"
  }

  provisioner "file" {
    source = "files/jenkins-slave-setup.yaml"
    destination = "/home/ubuntu/jenkins-slave-setup.yaml"
  }

  provisioner "file" {
    content     = <<-EOT
      [jenkins-master]
      ${aws_instance.jenkins-master.private_ip}

      [jenkins-master:vars]
      ansible_user=ubuntu
      ansible_ssh_private_key_file=/opt/${var.key_name_value}.pem

      [jenkins-slave]
      ${aws_instance.jenkins-slave.private_ip}

      [jenkins-slave:vars]
      ansible_user=ubuntu
      ansible_ssh_private_key_file=/opt/${var.key_name_value}.pem
    EOT
    destination = "/home/ubuntu/ansible-hosts"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Hello!!! Initiating remote exec'",
      "sudo apt update",
      "sudo apt install software-properties-common",
      "sudo add-apt-repository --yes --update ppa:ansible/ansible",
      "sudo apt update",
      "sudo apt install ansible -y",
      "ansible --version",
      "sudo mv /home/ubuntu/${var.key_name_value}.pem /opt/${var.key_name_value}.pem",
      "sudo mv /home/ubuntu/ansible-hosts /opt/ansible-hosts",
      "sudo mv /home/ubuntu/jenkins-master-setup.yaml /opt/jenkins-master-setup.yaml",
      "sudo mv /home/ubuntu/jenkins-slave-setup.yaml /opt/jenkins-slave-setup.yaml",
      "sudo chmod 400 /opt/${var.key_name_value}.pem",
      "export ANSIBLE_HOST_KEY_CHECKING=False",
      "ansible all -i /opt/ansible-hosts -m ping",
      "ansible-playbook -i /opt/ansible-hosts /opt/jenkins-master-setup.yaml --check",
      "ansible-playbook -i /opt/ansible-hosts /opt/jenkins-master-setup.yaml",
      "ansible-playbook -i /opt/ansible-hosts /opt/jenkins-slave-setup.yaml --check",
      "ansible-playbook -i /opt/ansible-hosts /opt/jenkins-slave-setup.yaml"
    ]
  }

}

resource "aws_instance" "jenkins-master" {
  ami                    = var.ami_value
  instance_type          = var.instance_type_value
  key_name               = var.key_name_value
  vpc_security_group_ids = [var.security_group_value]
  subnet_id              = var.subnet_id_value
  tags = {
    Name = "jenkins-master"
  }
}

resource "aws_instance" "jenkins-slave" {
  ami                    = var.ami_value
  instance_type          = var.instance_type_value
  key_name               = var.key_name_value
  vpc_security_group_ids = [var.security_group_value]
  subnet_id              = var.subnet_id_value
  tags = {
    Name = "jenkins-slave"
  }
}