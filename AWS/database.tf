resource "aws_db_instance" "moviedb" {
  allocated_storage   = 10
  engine              = "mysql"
  engine_version      = "8.0.23"
  instance_class      = "db.t2.micro"
  name                = "movie_db"
  username            = "admin"
  password            = "rampuptest2021"
  port                = 3306
  availability_zone   = "us-west-1a"
  publicly_accessible = false
  skip_final_snapshot = true
  tags = {
    project     = var.tags.project
    responsible = var.tags.responsible
  }
}

