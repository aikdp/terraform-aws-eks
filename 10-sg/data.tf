#Use SSM parameter store to store in aws and get the info using data source
data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project_name}/${var.environment}/vpc_id"
}
