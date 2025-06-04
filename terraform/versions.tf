terraform {
  required_version = ">=1.10.5"
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
      version = "3.0.0"
    }
  }
}

# Variables are not set in this file, they are set in the environment variables with "OS_" prefix
provider "openstack" {
  auth_url    = var.openstack_auth_url
  user_name   = var.openstack_user_name
  tenant_name = var.openstack_tenant_name
  password    = var.openstack_password
  region      = var.openstack_region

}