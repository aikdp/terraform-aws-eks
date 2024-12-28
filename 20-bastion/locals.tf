locals {
  resource_name = "${var.project_name}-${var.environment}"      #expense-dev
  bastion_sg_id = data.aws_ssm_parameter.bastion_sg_id.value
  public_subnet_id = split(",", data.aws_ssm_parameter.public_subnet_ids.value)[0]  #subnet id whcih are stored in SSM is STRINGLIST type"sub08989, sub0089udiaij", but we need list of string means-->["sub989uc9u09c0"]
  
}

