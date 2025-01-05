#Use SSM parameter to store in aws and get the info using data source
data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project_name}/${var.environment}/vpc_id"
}

#Use SSM parameter to store in aws and get the info using data source
data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/public_subnet_ids"
}


#Use SSM parameter to store in aws and get the info using data source
data "aws_ssm_parameter" "ingress_alb_sg_id" {
  name = "/${var.project_name}/${var.environment}/ingress_alb_sg_id"
}



#Use SSM parameter to store in aws and get the info using data source
data "aws_ssm_parameter" "https_certificate_arn" {
  name = "/${var.project_name}/${var.environment}/https_certificate_arn"
}
