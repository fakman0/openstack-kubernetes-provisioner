# Create the network
resource "openstack_networking_network_v2" "kubernetes" {
  name           = var.network_name
  admin_state_up = true
}

# Create the subnet
resource "openstack_networking_subnet_v2" "kubernetes" {
  name            = "${var.network_name}-subnet"
  network_id      = openstack_networking_network_v2.kubernetes.id
  cidr            = var.subnet_cidr
  ip_version      = 4
  dns_nameservers = var.dns_nameservers
}

# Create router
resource "openstack_networking_router_v2" "kubernetes" {
  name                = var.router_name
  admin_state_up      = true
  external_network_id = data.openstack_networking_network_v2.external.id
}

# Get external network
data "openstack_networking_network_v2" "external" {
  name = "public"  # This is often named "public" or "external" - change if needed
}

# Attach router to subnet
resource "openstack_networking_router_interface_v2" "kubernetes" {
  router_id = openstack_networking_router_v2.kubernetes.id
  subnet_id = openstack_networking_subnet_v2.kubernetes.id
}

# Create security group for Kubernetes
resource "openstack_networking_secgroup_v2" "kubernetes" {
  name        = "kubernetes-secgroup"
  description = "Security group for Kubernetes cluster"
}

# Allow ARP requests
resource "openstack_networking_secgroup_rule_v2" "ARP" {
  direction         = "ingress"
  remote_group_id   = openstack_networking_secgroup_v2.kubernetes.id
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.kubernetes.id
}

# Allow all internal communication between nodes
resource "openstack_networking_secgroup_rule_v2" "internal" {
  direction         = "ingress"
  ethertype         = "IPv4"
  remote_ip_prefix  = var.subnet_cidr
  security_group_id = openstack_networking_secgroup_v2.kubernetes.id
  description       = "Allow all internal communication between nodes"
}

# Allow SSH access
resource "openstack_networking_secgroup_rule_v2" "ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.kubernetes.id
  description       = "Allow SSH access"
}

# Allow HTTPS/Kubernetes API
resource "openstack_networking_secgroup_rule_v2" "kube_api" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 6443
  port_range_max    = 6443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.kubernetes.id
  description       = "Allow HTTPS/Kubernetes API"
}

# Allow ICMP
resource "openstack_networking_secgroup_rule_v2" "icmp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.kubernetes.id
  description       = "Allow ICMP"
}

# Allow NodePort services
resource "openstack_networking_secgroup_rule_v2" "nodeport" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 30000
  port_range_max    = 32767
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.kubernetes.id
}

# Reserve a floating IP for the Kubernetes control plane (master-1)
resource "openstack_networking_floatingip_v2" "control_plane" {
  pool = "public"  # Change to your external network name if different
}