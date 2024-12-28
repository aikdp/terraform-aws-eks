locals {
  resource_name = "${var.project_name}-${var.environment}"      #expense-dev
  private_subnet_ids = split(",", data.aws_ssm_parameter.private_subnet_ids.value)  #subnet id whcih are stored in SSM is STRINGLIST type"sub08989, sub0089udiaij", but we need list of string means-->["sub989uc9u09c0"]
  node_sg_id = data.aws_ssm_parameter.node_sg_id.value
  eks_control_plane_sg = data.aws_ssm_parameter.eks_control_plane_sg_id.value
  
}

