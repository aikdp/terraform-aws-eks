#Use SSM parameter to store in aws and get the info using data source
data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project_name}/${var.environment}/vpc_id"
}

#Use SSM parameter to store in aws and get the info using data source
data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/private_subnet_ids"
}

#Use SSM parameter to store in aws and get the info using data source
data "aws_ssm_parameter" "eks_control_plane_sg_id" {
  name = "/${var.project_name}/${var.environment}/eks_control_plane_sg_id"
}

#Use SSM parameter to store in aws and get the info using data source
data "aws_ssm_parameter" "node_sg_id" {
  name = "/${var.project_name}/${var.environment}/node_sg_id"
}

