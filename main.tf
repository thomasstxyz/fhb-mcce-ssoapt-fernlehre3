# Data Source for getting Amazon Linux AMI
data "aws_ami" "amazon-2" {
  most_recent = true

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
}

# Resource for podtatohead-main
resource "aws_instance" "podtatohead-main" {
  key_name = "aws-aca"
  ami = data.aws_ami.amazon-2.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.ingress-all-ssh.id, aws_security_group.ingress-all-http.id, aws_security_group.ingress-all-80.id, aws_security_group.ingress-all-443.id]

  user_data = templatefile("${path.module}/templates/init_main.tftpl", { container_image = "ghcr.io/fhb-codelabs/podtato-small-main", hats_host = aws_instance.podtatohead-hats.private_ip, arms_host = aws_instance.podtatohead-arms.private_ip, legs_host = aws_instance.podtatohead-legs.private_ip, podtato_version=var.podtato_version } )

  tags = {
    Name = "podtatohead-main"
  }
}

# Resource for podtatohead-legs
resource "aws_instance" "podtatohead-legs" {
  key_name = "aws-aca"
  ami = data.aws_ami.amazon-2.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.ingress-all-ssh.id, aws_security_group.ingress-all-http.id]

  user_data = templatefile("${path.module}/templates/init.tftpl", { container_image = "ghcr.io/fhb-codelabs/podtato-small-legs", podtato_version=var.podtato_version, left_version=var.left_leg_version, right_version=var.right_leg_version} )

  tags = {
    Name = "podtatohead-legs"
  }
}

# Resource for podtatohead-arms
resource "aws_instance" "podtatohead-arms" {
  key_name = "aws-aca"
  ami = data.aws_ami.amazon-2.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.ingress-all-ssh.id, aws_security_group.ingress-all-http.id]

  user_data = templatefile("${path.module}/templates/init.tftpl", { container_image = "ghcr.io/fhb-codelabs/podtato-small-arms", podtato_version=var.podtato_version, left_version=var.left_arm_version, right_version=var.right_arm_version } )

  tags = {
    Name = "podtatohead-arms"
  }
}

# Resource for podtatohead-hats
resource "aws_instance" "podtatohead-hats" {
  key_name = "aws-aca"
  ami = data.aws_ami.amazon-2.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.ingress-all-ssh.id, aws_security_group.ingress-all-http.id]

  user_data = templatefile("${path.module}/templates/init_hats.tftpl", { container_image = "ghcr.io/fhb-codelabs/podtato-small-hats", podtato_version=var.podtato_version, version=var.hats_version, checksum_hat=var.hats_checksum } )

  tags = {
    Name = "podtatohead-hats"
  }
}

resource "aws_security_group" "ingress-all-ssh" {
  name = "allow-all-ssh"
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  // Terraform removes the default rule
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ingress-all-http" {
  name = "allow-all-http"
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
  }
  // Terraform removes the default rule
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ingress-all-80" {
  name = "allow-all-80"
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 80
    to_port = 80
    protocol = "tcp"
  }
  // Terraform removes the default rule
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ingress-all-443" {
  name = "allow-all-443"
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 443
    to_port = 443
    protocol = "tcp"
  }
  // Terraform removes the default rule
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
