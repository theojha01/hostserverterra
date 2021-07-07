variable "vpc_id" {}
resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  description = "SG for Database (SQL) instances"
  vpc_id      = var.vpc_id
ingress {
    description = "Allow SQL DB Access only for port 3306"
    from_port   = 3306
    to_port     = 3306
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#--------- OUTPUTS FOR SECURITY GROUP ---------#
output "db_sg"{
  value = aws_security_group.db_sg
}
