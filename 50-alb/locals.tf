locals {
  resource_name = "${var.project_name}-${var.environment}"      #expense-dev
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  public_subnet_id = split(",", data.aws_ssm_parameter.public_subnet_ids.value)
  ingress_alb_sg_id = data.aws_ssm_parameter.ingress_alb_sg_id.value
  https_certificate_arn = data.aws_ssm_parameter.https_certificate_arn.value
}

  # db_subnet_ids = split(",", data.aws_ssm_parameter.database_subnet_ids[*].value)