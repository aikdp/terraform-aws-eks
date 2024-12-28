#Creating Key Pair
resource "aws_key_pair" "eks" {
  key_name   = "eks"
  public_key = file("~/.ssh/eks.pub")  #ath to your public key file
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
#   version = "~> 20.31"

  cluster_name    = "${var.project_name}-${var.environment}"    #expense-dev
  cluster_version = "1.31"  #Our goal is upgrade version to 1.31

  # Optional
  cluster_endpoint_public_access = true

    cluster_addons = {
        coredns                = {}
        eks-pod-identity-agent = {}
        kube-proxy             = {}
        vpc-cni                = {}
    }

    vpc_id     = data.aws_ssm_parameter.vpc_id.value    
    subnet_ids = local.private_subnet_ids
    control_plane_subnet_ids =local.private_subnet_ids

    create_cluster_security_group = false   #here we are using EKS Control SG, we have already created. so don't create default SG (Evertrhin should be in oour control right)
    cluster_security_group_id = local.eks_control_plane_sg

    create_node_security_group = false  #Don't create default SG, So put False
    node_security_group_id = local.node_sg_id

    # EKS Managed Node Group(s)
    eks_managed_node_group_defaults = {

        instance_types         = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]   #select these type of instances
    } 

    eks_managed_node_groups = {
    #   blue = {                        #we are upgrading using Blue-Green Deployement without downtime
    #     min_size     = 2
    #     max_size     = 10
    #     desired_size = 2

    # #   capacity_type  = "SPOT" #due to spot, we get some disturbences....Hence Comment it

    #     iam_role_additional_policies = {
    #       AmazonEBSCSIDriverPolicy          = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
    #       AmazonElasticFileSystemFullAccess = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"     #add EFS CSI driver -->AWS-->IAM-->Policies-->Search: EFS-->add it
    #       ElasticLoadBalancingFullAccess = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
    #    }
    #   # EKS takes AWS Linux 2 as it's OS to the nodes
    #    key_name = aws_key_pair.eks.key_name
    # }

    green = {                        #we are upgrading using Blue-Green Deployement without downtime
      min_size     = 2
      max_size     = 10
      desired_size = 2

    #   capacity_type  = "SPOT" #due to spot, we get some disturbences....Hence Comment it

      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy          = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
        AmazonElasticFileSystemFullAccess = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"     #add EFS CSI driver -->AWS-->IAM-->Policies-->Search: EFS-->add it
        ElasticLoadBalancingFullAccess = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
      }
      # EKS takes AWS Linux 2 as it's OS to the nodes
      key_name = aws_key_pair.eks.key_name
    }
  }

  # Cluster access entry
  # To add the current caller identity as an administrator
  enable_cluster_creator_admin_permissions = true


  tags = var.common_tags
}



#1. Create Green Node group with same capacity and Uncomment GREEn NG and Apply terraform 
#2. CORDON GREEN Nodes (Cordon the Node: Prevent new pods from being scheduled on the node)
#3. Upgrade Cluster to 1.31 in AWS EKS CONSOLE
#4. Upgrade GREEN Node Group to 1.31 in CONSOLE
#5. CORDON Blue Node group
#6. UNCORDON GREEN NODe Group --->Its automatically uncordon, means it will be in READY 
#7. Drain Blue Node Group (Drain the Node: Evict all pods from the node)
#8. Change version to 1.31 in TF Code,,, and Comment Blue Node group code and TF APPLY
#9. Blue Node Deleted --Automatucally Delete

#Cluster Upgradation completed without downtime.