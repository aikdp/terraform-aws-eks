locals {
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    # node_sg_id = data.aws_ssm_parameter.node_sg_id.value
}