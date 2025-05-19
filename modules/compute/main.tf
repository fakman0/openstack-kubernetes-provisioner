# Create master nodes
resource "openstack_compute_instance_v2" "master" {
  count             = var.master_count
  name              = "kubernetes-master-${count.index + 1}"
  image_id          = var.image_id
  flavor_name       = var.master_flavor
  key_pair          = var.keypair_name
  security_groups   = ["default", openstack_compute_secgroup_v2.kubernetes.name]

  network {
    uuid = var.network_id
  }

  user_data = file("${path.module}/cloud-init.yaml")

  # Assign floating IP to the first master node for external access
  dynamic "network" {
    for_each = count.index == 0 ? [1] : []
    content {
      name = "public"  # Change to match your external network name if different
    }
  }
}

# Create worker nodes
resource "openstack_compute_instance_v2" "worker" {
  count             = var.worker_count
  name              = "kubernetes-worker-${count.index + 1}"
  image_id          = var.image_id
  flavor_name       = var.worker_flavor
  key_pair          = var.keypair_name
  security_groups   = ["default", openstack_compute_secgroup_v2.kubernetes.name]

  network {
    uuid = var.network_id
  }

  user_data = file("${path.module}/cloud-init.yaml")
}

# Attach volumes to master nodes
resource "openstack_compute_volume_attach_v2" "master_volume_attachment" {
  count       = var.master_count
  instance_id = openstack_compute_instance_v2.master[count.index].id
  volume_id   = var.master_volume_ids[count.index]
}

# Attach volumes to worker nodes
resource "openstack_compute_volume_attach_v2" "worker_volume_attachment" {
  count       = var.worker_count
  instance_id = openstack_compute_instance_v2.worker[count.index].id
  volume_id   = var.worker_volume_ids[count.index]
}

# Create a separate security group for the instances to avoid circular dependencies
resource "openstack_compute_secgroup_v2" "kubernetes" {
  name        = "kubernetes-instances-secgroup"
  description = "Security group for Kubernetes instances"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 6443
    to_port     = 6443
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 1
    to_port     = 65535
    ip_protocol = "tcp"
    self        = true
  }

  rule {
    from_port   = 1
    to_port     = 65535
    ip_protocol = "udp"
    self        = true
  }

  rule {
    from_port   = -1
    to_port     = -1
    ip_protocol = "icmp"
    cidr        = "0.0.0.0/0"
  }
}

# Create floating IPs for master nodes
resource "openstack_networking_floatingip_v2" "master" {
  count = var.master_count
  pool  = "public"  # Change this to your external network name if different
}

# Associate floating IPs with master nodes
resource "openstack_compute_floatingip_associate_v2" "master" {
  count       = var.master_count
  floating_ip = openstack_networking_floatingip_v2.master[count.index].address
  instance_id = openstack_compute_instance_v2.master[count.index].id
}
