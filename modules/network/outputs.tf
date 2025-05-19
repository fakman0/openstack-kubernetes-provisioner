output "network_id" {
  description = "ID of the created network"
  value       = openstack_networking_network_v2.kubernetes.id
}

output "subnet_id" {
  description = "ID of the created subnet"
  value       = openstack_networking_subnet_v2.kubernetes.id
}

output "router_id" {
  description = "ID of the created router"
  value       = openstack_networking_router_v2.kubernetes.id
}

output "security_group_id" {
  description = "ID of the created security group"
  value       = openstack_networking_secgroup_v2.kubernetes.id
}
