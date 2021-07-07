provider "aws" {
  profile = var.profile_name
  region  = var.region_name
}
module "sg_rds" {
  source = "./my_sg"
  vpc_id = var.vpc_id
}
module "rds_inst" {
  source = "./my_rds"
  db_sg = module.sg_rds.db_sg
  alloc_store = 10
  store_type = "gp2"
  engine = "mysql"
  engine_ver = "5.7.30"
  inst_type = "db.t2.micro"
  db_name = "my_db"
  db_username = "ananya"
  db_password = "ananya123"
  
}
provider "kubernetes" {
  config_context_cluster = var.cluster_name
}
module "wordpress" {
  source = "./my_k8s_wp"
  deploy_name = "wp-dp"
  deploy_label = "wp"
  pod_replicas = 1
  pod_label = "wp"
  pod_img = var.pod_img
}
output "db_name" {
  value = "Database name: ${module.rds_inst.db_name}"
}
output "db_addr" {
  value = "Database Host Address: ${module.rds_inst.db_addr}"
}
output "db_username" {
  value = "Username for DB Access: ${module.rds_inst.db_username}"
}
output "db_passwd" {
  value = "Password for DB Access: ${module.rds_inst.db_passwd}" 
}
