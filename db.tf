resource "aws_db_subnet_group" "sbcntr_db" {
  name       = "sbcntr-rds-subnet-group"
  subnet_ids = local.subnet_ids.db
}