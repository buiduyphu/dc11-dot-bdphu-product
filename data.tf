data "aws_vpc" "networking-VPC" {
  tags = {
    Name = "dc11-networking-VPC"
  }
}

data "aws_subnets" "vpc" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.networking-VPC.id]
  }
}

data "aws_subnet" "all" {
    for_each = toset(data.aws_subnets.vpc.ids)
    id       = each.value
}