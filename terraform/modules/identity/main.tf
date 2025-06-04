resource "openstack_identity_application_credential_v3" "occm-credential" {
  name        = "occm-credential"
  description = "Openstack cloud controller manager credential"
  roles       = ["member", "reader", "load-balancer_member"]
}