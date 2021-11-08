resource "aws_db_instance" "moviedb_ccardenas" {
  identifier             = "moviedbccardenas"
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "8.0.23"
  instance_class         = "db.t2.micro"
  name                   = "movie_db"
  username               = "admin"
  password               = "rampuptest2021"
  db_subnet_group_name   = aws_db_subnet_group.subnet_group_ccardenas.name
  vpc_security_group_ids = ["sg-068b2c295fafbcbf8"]
  port                   = 3306
  publicly_accessible    = false
  skip_final_snapshot    = true
  tags = {
    project     = var.tags.project
    responsible = var.tags.responsible
  }
}

resource "aws_db_subnet_group" "subnet_group_ccardenas" {
  name       = "subnet_group_ccardenas"
  subnet_ids = [data.aws_subnet.ramp_up_training-private-0.id, data.aws_subnet.ramp_up_training-private-1.id]

  tags = {
    project     = var.tags.project
    responsible = var.tags.responsible
  }
}

