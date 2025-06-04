output "application_credential_id" {
  value = openstack_identity_application_credential_v3.occm-credential.id
}

output "application_credential_secret" {
  value = openstack_identity_application_credential_v3.occm-credential.secret
  sensitive = true
}