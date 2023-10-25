# output "vpc_id" {
#   value = [
#     for s in data.aws_vpc.networking-VPC : s
#   ]
# }

# output "subnet_private_cidr_blocks" {
#   value = [
#     for s in data.aws_subnet.all : s
#     if can(regex("^private-subnet", s.tags.Name))
#   ]
# }