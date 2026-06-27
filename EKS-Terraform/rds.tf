############################
# RDS - MySQL
# Cluster context: vishva
# instance_class db.t3.micro -> free-tier eligible
# multi_az kept true for HA (note: multi_az may incur cost on free tier)
############################

resource "aws_db_subnet_group" "sub-grp" {
  name       = "main"
  subnet_ids = [aws_subnet.private1.id, aws_subnet.private2.id]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "rds" {
  allocated_storage      = 20
  identifier             = "microservices-rds"
  db_subnet_group_name   = aws_db_subnet_group.sub-grp.id
  engine                 = "mysql"
  engine_version         = "8.4.8"

  # db.t3.micro is free-tier eligible (750 hours/month on new accounts)
  instance_class         = "db.t3.micro"

  # NOTE: multi_az = true runs a standby replica in a second AZ.
  # Free tier covers only the primary instance hours.
  # Set to false if you want to stay strictly within free tier limits.
  multi_az               = false

  db_name                = "mydb"
  username               = "admin"
  password               = "Cloud123"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.allow_all.id]

  depends_on = [aws_db_subnet_group.sub-grp]

  publicly_accessible     = true
  backup_retention_period = 7

  tags = {
    DB_identifier = "vishva-rds"
    Project       = "eks-project"
    Owner         = "vishvaops"
  }
}
