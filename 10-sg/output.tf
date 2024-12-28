output "mysql_sg_id" {
  value       = module.mysql_sg.id
}

output "node_sg_id" {
  value       = module.node_sg.id
}

output "eks_control_plane_sg_id" {
  value       = module.eks_control_plane_sg.id
}

output "bastion_sg_id" {
  value       = module.bastion_sg.id
}

output "ingress_alb_sg_id" {
  value       = module.ingress_alb_sg.id
}
