locals {
  resource_name = "${var.project_name}-${var.environment}"      #expense-dev
}

  # db_subnet_ids = split(",", data.aws_ssm_parameter.database_subnet_ids[*].value)