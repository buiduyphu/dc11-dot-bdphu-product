
resource "aws_db_subnet_group" "mydb_subnet_group" {
  name            = "mysql-db-subnet-group"
  subnet_ids      = local.subnet_private_ids

   tags = {
    Name = "mysql-db-subnet-private-group"
  }
}

resource "aws_security_group" "rds" {
  name        = "rds-sg"
  description = "Security group for RDS"
  vpc_id        = data.aws_vpc.networking-VPC.id
  ingress {
    from_port   = 3306
    to_port     = 3306
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
    Name = "devops-rds-security-group"
  }
}

resource "aws_db_instance" "mysql_rds" {

  vpc_security_group_ids = [aws_security_group.rds.id]

  allocated_storage    = 20
  storage_type         = "gp2"

  engine               = "mysql"
  engine_version       = "8.0.33"
  instance_class       = "db.t2.micro"

  db_name              = "dc11database"
  username             = "admin"
  password             = "12345678"

  #parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true

  db_subnet_group_name = aws_db_subnet_group.mydb_subnet_group.name
  
  tags = {
    name = "devops-rds-mysql"
  }
}
