output "master_ips" {
  description = "IP addresses of the Kubernetes master nodes"
  value       = module.compute.master_ips
}

output "worker_ips" {
  description = "IP addresses of the Kubernetes worker nodes"
  value       = module.compute.worker_ips
}

output "network_id" {
  description = "ID of the created network"
  value       = module.network.network_id
}

output "subnet_id" {
  description = "ID of the created subnet"
  value       = module.network.subnet_id
}

output "router_id" {
  description = "ID of the created router"
  value       = module.network.router_id
}

output "security_group_id" {
  description = "ID of the created security group"
  value       = module.network.security_group_id
}
