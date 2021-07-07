variable db_sg {}
variable alloc_store {}
variable store_type {}
variable engine {}
variable engine_ver {}
variable inst_type {}
variable db_name {}
variable db_username {}
variable db_password {}
resource "aws_db_instance" "rds_inst" {
  depends_on        = [var.db_sg]
  allocated_storage = var.alloc_store # Storage size for DB
  storage_type      = var.store_type #Storage type of DB
  engine = var.engine # Type of DB Engine (Eg: mysql, mariadb)
  vpc_security_group_ids = [var.db_sg.id]
  engine_version         = var.engine_ver 
  instance_class         = var.inst_type #DB instance type (Eg: db.t2.micro)
  
  # Giving Credentials for the DB table and user access
  name                 = var.db_name
  username             = var.db_username
  password             = var.db_password
  
  # Making the DB publicly accessible to integrate with WordPress running on K8s
  publicly_accessible = true
  
  # Setting this true so that there will be no problem while destroying the infrastructure
  skip_final_snapshot = true
tags = {
    Name = "my_rds_db"
  }
}
#--------- OUTPUTS FOR RDS DATABASE ---------#
# Gives DB table name
output "db_name" {
  value = aws_db_instance.rds_inst.name
}
# Gives the DB host address
output "db_addr" {
  value = aws_db_instance.rds_inst.address
}
# Gives the username for DB access
output "db_username" {
  value = aws_db_instance.rds_inst.username
}
# Gives the password for DB access
output "db_passwd" {
  value = aws_db_instance.rds_inst.password
}
