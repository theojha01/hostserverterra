variable "profile_name" {
  type = string
  default = "your-profile-name"
}
variable "region_name" {
  type = string
  default = "ap-south-1"
}
#------------ VARIABLES FOR VPC -------------#
variable "vpc_id" {
  type = string
  default = "your vpc-id"
}
#------------ VARIABLES FOR KUBERNETES CLUSTER -------------#
variable "cluster_name" {
  type = string
  default = "minikube"
}
variable "pod_img" {
  type = string
  default = "wordpress"
}
variable "update_method" {
  type = string
  default = "RollingUpdate"
}
/* Configuring AWS and Kubernetes providers in main.tf */
provider "aws" {
  profile = var.profile_name
  region  = var.region_name
}
provider "kubernetes" {
  config_context_cluster = var.cluster_name
}
