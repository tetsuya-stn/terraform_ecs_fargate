resource "aws_db_subnet_group" "sbcntr_db" {
  name        = "sbcntr-rds-subnet-group"
  subnet_ids  = local.subnet_ids.db
  description = "ECS/Fargate handson"
}

resource "aws_rds_cluster" "sbcntr_db" {
  cluster_identifier      = "sbcntr-db"
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.10.2"
  availability_zones      = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
  storage_encrypted       = true
  port                    = 3306
  db_subnet_group_name    = aws_db_subnet_group.sbcntr_db.name
  database_name           = "sbcntrapp"
  master_username         = "admin"
  master_password         = "kiwo78gTFvbGG2567"
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
  vpc_security_group_ids = [
    local.security_group_id.db,
  ]
}

resource "aws_rds_cluster_instance" "sbcntr_db" {
  identifier         = "sbcntr-db"
  cluster_identifier = aws_rds_cluster.sbcntr_db.id
  instance_class     = "db.t3.small"
  engine             = aws_rds_cluster.sbcntr_db.engine
  engine_version     = aws_rds_cluster.sbcntr_db.engine_version
}

#resource "local_file" "mysql_config_file" {
#  filename = "./.my.cnf"
#  content  = templatefile("./sql/aurora_mysql.cnf", {
#    aurora_user     = aws_rds_cluster.sbcntr_db.master_username
#    aurora_password = aws_rds_cluster.sbcntr_db.master_password
#    aurora_host     = aws_rds_cluster.sbcntr_db.endpoint
#    aurora_port     = 3306
#  })
#}

#resource "null_resource" "sbcntr_db_setup" {
#  depends_on = [
#    aws_rds_cluster.sbcntr_db,
#    aws_rds_cluster_instance.sbcntr_db,
#  ]
#
#  provisioner "local-exec" {
#    command = "mysql --defaults-extra-file=./.my.cnf ${aws_rds_cluster.sbcntr_db.database_name} < ./sql/aurora_setup.sql"
#  }
#}
