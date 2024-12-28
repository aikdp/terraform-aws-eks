module "vpc"{
    source = "git::https://github.com/aikdp/01-terraform-aws-vpc.git?ref=main"
    vpc_cidr = var.vpc_cidr_kdp
    project_name = var.project_name
    environment = var.environment
    common_tags = var.common_tags_vpc
    public_subnet_cidrs = var.subnet_public_cidrs
    private_subnet_cidrs = var.subnet_private_cidrs
    database_subnet_cidrs = var.subnet_database_cidrs
    is_peer_required = var.peering_required
} 