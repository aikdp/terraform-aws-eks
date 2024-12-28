#MySQL SG and DATABASE Subnet
#Node SG and Priavte Subnet
#EKS Control Plane SG 
#IAM ROle
#Ingress ALB SG and Public Subnet
#Bastion SG   
###
#SG RULES:
#MySQL_bastion----
#Node_Ingress ALB---
##Node_Bastion---
#EKS_NOde----
#EKS_bastion---
#NODE_EKS----
#Ingress ALB_HTTPS---
#Bastion_public---
#Node_VPC(VPC CIDR because IPs are not permanent, pods will increase and decrease right)---


#Create MySQL Security Group
module "mysql_sg" {
    source = "git::https://github.com/aikdp/terraform-aws-security-group.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    common_tags = var.common_tags
    sg_name = "mysql"
    sg_tags = var.mysql_sg_tags
    vpc_id = local.vpc_id   #get it from data source, we already store at ssm parameter
}

#Create NODE Security Group
module "node_sg" {
    source = "git::https://github.com/aikdp/terraform-aws-security-group.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    common_tags = var.common_tags
    sg_name = "node"
    sg_tags = var.node_sg_tags
    vpc_id = local.vpc_id   #get it from data source, we already store at ssm parameter
}

#Create EKS Control Plane Security Group
module "eks_control_plane_sg" {
    source = "git::https://github.com/aikdp/terraform-aws-security-group.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    common_tags = var.common_tags
    sg_name = "eks-control-plane"
    sg_tags = var.eks_control_plane_sg_tags
    vpc_id = local.vpc_id   #get it from data source, we already store at ssm parameter
}

#Create INGRESS ALB Security Group
module "ingress_alb_sg" {
    source = "git::https://github.com/aikdp/terraform-aws-security-group.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    common_tags = var.common_tags
    sg_name = "ingress-alb"
    sg_tags = var.ingress_alb_sg_tags
    vpc_id = local.vpc_id   #get it from data source, we already store at ssm parameter
}

#Create FRONTEND Security Group
module "bastion_sg" {
    source = "git::https://github.com/aikdp/terraform-aws-security-group.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    common_tags = var.common_tags
    sg_name = "bastion"
    sg_tags = var.bastion_sg_tags
    vpc_id = local.vpc_id   #get it from data source, we already store at ssm parameter
}

###
#SG RULES:
#MySQL_bastion----1
#Node_Ingress ALB---2
##Node_Bastion---3
#EKS_NOde----4
#EKS_bastion---5
#NODE_EKS----6
#Ingress ALB_HTTPS---7
#Bastion_public---8
#Node_VPC(VPC CIDR because IPs are not permanent, pods will increase and decrease right)---9



#Create Security group rules for allow traffic from bastion to mysql
resource "aws_security_group_rule" "mysql_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.id  
  security_group_id = module.mysql_sg.id 
}

#Create Security group rules for allow traffic from ingress_alb to node (worker nodes)
resource "aws_security_group_rule" "node_ingress_alb" {
  type              = "ingress"
  from_port         = 30000
  to_port           = 32767
  protocol          = "tcp"
  source_security_group_id = module.ingress_alb_sg.id  
  security_group_id = module.node_sg.id 
}

#Create Security group rules for allow traffic from bastion to node (worker nodes)
resource "aws_security_group_rule" "node_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.id  
  security_group_id = module.node_sg.id 
}

#Create Security group rules for allow traffic from node (worker nodes) to eks control plane
resource "aws_security_group_rule" "eks_node" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  source_security_group_id = module.node_sg.id  
  security_group_id = module.eks_control_plane_sg.id 
}

#Create Security group rules for allow traffic from node (worker nodes) to eks control plane
resource "aws_security_group_rule" "node_eks" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  source_security_group_id = module.eks_control_plane_sg.id  
  security_group_id = module.node_sg.id 
}


#Create Security group rules for allow traffic from bastion to eks control plane
resource "aws_security_group_rule" "eks_bastion" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.id  
  security_group_id = module.eks_control_plane_sg.id 
}

#Create Security group rules for allow traffic from HTTPS Public to Ingress ALB
resource "aws_security_group_rule" "ingress_alb_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.ingress_alb_sg.id 
}


#Create Security group rules for allow traffic from public to Bastion
resource "aws_security_group_rule" "bastion_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]  
  security_group_id = module.bastion_sg.id 
}


#Create Security group rules for allow traffic from VPC CIDR (all trffic: pod to pod ) to node (Worker node)
resource "aws_security_group_rule" "node_vpc_cidr" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["10.0.0.0/16"] 
  security_group_id = module.node_sg.id 
}
