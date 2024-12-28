output "vpc_id_mine" {
    value = module.vpc.vpc_id
}

output "az_zones"{
    value = module.vpc.az_info
}

output "public_subnet_ids"{
    value = module.vpc.public_subnet_ids
}
output "private_subnet_ids"{
    value = module.vpc.private_subnet_ids
}
output "database_subnet_ids"{
    value = module.vpc.database_subnet_ids
}