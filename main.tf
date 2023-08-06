terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.11.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# provider "random" {
#   # Configuration options
# }
data "aws_ami" "latest_ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical account ID for official Ubuntu AMIs
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}
resource "random_password" "token" {
  length  = 16
  special = false

}

resource "aws_instance" "master" {
  ami                    = data.aws_ami.latest_ubuntu.id
  instance_type          = var.instancetype
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.K3S-sec-grp.id]
  user_data              = data.template_file.master.rendered
tags = {
  Name = "master"
}
}

resource "aws_instance" "worker" {
  ami                    = data.aws_ami.latest_ubuntu.id
  instance_type          = var.instancetype
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.K3S-sec-grp.id]
  user_data              = data.template_file.worker.rendered
  tags = {
    Name = "worker"
  }
  depends_on = [aws_instance.master]
}

data "template_file" "master" {
  template = file("${abspath(path.module)}/master.sh")
  vars = {
  sifre = random_password.token.result
  }
}
data "template_file" "worker" {
  template = file("${abspath(path.module)}/worker.sh")
  vars = {
  sifre = random_password.token.result
  url = "https://${aws_instance.master.private_ip}:6443" 
  }
}


resource "aws_security_group" "K3S-sec-grp" {
  name = "k3s-sec-grp-tf"
  tags = {
    Name = "k3s-sec-grp-tf"
  }

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6443
    protocol    = "tcp"
    to_port     = 6443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8472
    protocol    = "udp"
    to_port     = 8472
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = -1
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}


