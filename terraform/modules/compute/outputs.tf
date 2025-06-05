output "master_ips" {
  description = "IP addresses of the Kubernetes master nodes"
  value       = openstack_compute_instance_v2.master[*].access_ip_v4
}

output "worker_ips" {
  description = "IP addresses of the Kubernetes worker nodes"
  value       = openstack_compute_instance_v2.worker[*].access_ip_v4
}

output "master_private_ips" {
  description = "Private IP addresses of the Kubernetes master nodes"
  value       = openstack_compute_instance_v2.master[*].access_ip_v4
}

output "master_instance_ids" {
  description = "IDs of the master instances"
  value       = openstack_compute_instance_v2.master[*].id
}

output "worker_instance_ids" {
  description = "IDs of the worker instances"
  value       = openstack_compute_instance_v2.worker[*].id
}

output "master_instances_map" {
  description = "Map of master instance names to their IDs"
  value = {
    for i, instance in openstack_compute_instance_v2.master :
    "master-${i+1}" => instance.id
  }
}

output "worker_instances_map" {
  description = "Map of worker instance names to their IDs"
  value = {
    for i, instance in openstack_compute_instance_v2.worker :
    "worker-${i+1}" => instance.id
  }
}
