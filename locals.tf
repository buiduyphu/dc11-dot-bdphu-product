# locals {
#   config_file_name      = "${terraform.workspace}.tfvars"
#   full_config_file_path = "variables/${local.config_file_name}"
#   vars                  = yamldecode(file(local.full_config_file_path))
# }


locals {
  subnet_private_ids = [
    for s in data.aws_subnet.all : s.id
    if can(regex("private-subnet", s.tags.Name))
  ]

  subnet_public = [
    for s in data.aws_subnet.all : s
    if can(regex("^public-subnet", s.tags.Name))
  ]
}