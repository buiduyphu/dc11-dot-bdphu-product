resource "aws_ebs_volume" "ec2" {
  count             = 2
  availability_zone = local.subnet_public[count.index].availability_zone
  size              = 8
  type              = "gp2"

  tags = {
    Name = "dc11-devops-ebs-ec2-${count.index}"
  }
}

resource "aws_network_interface" "ec2" {
  count           = 2
  subnet_id       = local.subnet_public[count.index].id
  security_groups = [aws_security_group.ec2.id]
}

resource "aws_security_group" "ec2" {
  name   = "dc11-ec2-sg"
  vpc_id = data.aws_vpc.networking-VPC.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dc11-devops-ec2-sg"
  }
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "ec2-ssh-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCvU3Wo3HT7XTo1HX6D/5/+GBYK7WzmwheThNlE067VUvNZTGvNxY7tmTcS804jAj8RdSwRYZzP09gYNAX8oo/TO8dSs9ZIIkZSCUhelk0Hirkv8F6UFiBkdSAg2wn6rL0lY/oPSkwDsxTw0/QxjsBCw7Kk8RWkgRnX5DPH0UhBI8JEsx2KpwNfq6IBlnsV9+LuO7bD9KZ/HXQZeEi9Zm6Mu8+IuLx1DRjmI9RZi91UqTCa2+CovSZ9a72aVta3rH4G4a1FYU7M1cyQh5kcZ2bWJxIcHYY6hcpctaq34cCE2i6yYda9+QxjrKh106VsxicBboPN6/XDi2SaAI4+nObB"
}

resource "aws_instance" "ec2" {

  count         = 2
  ami           = "ami-0df4b2961410d4cff"
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.ec2[count.index].id
    device_index         = 0
  }

  key_name = aws_key_pair.ec2_key_pair.key_name

  tags = {
    Name = "dc11-devops-ec2-${count.index}"
  }
}

resource "aws_volume_attachment" "ec2_ubuntu" {
  count       = 2
  device_name = "/dev/sda2"
  volume_id   = aws_ebs_volume.ec2[count.index].id
  instance_id = aws_instance.ec2[count.index].id
}

resource "aws_eip" "ec2" {
  count    = 2
  instance = aws_instance.ec2[count.index].id

  domain = "vpc"

  tags = {
    Name = "dc11-devops-ec2-eip-${count.index}"
  }
}

resource "aws_ec2_instance_state" "test" {
  count       = 2
  instance_id = aws_instance.ec2[count.index].id
  state       = "running"
}