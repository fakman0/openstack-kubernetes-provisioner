# Kubernetes Cluster on OpenStack with Terraform

This Terraform project creates a Kubernetes cluster on OpenStack with the following components:

- Network infrastructure (VPC, subnet, router, security groups)
- Persistent volumes for Kubernetes nodes
- 3 master and 3 worker nodes pre-configured with Kubernetes dependencies

## Directory Structure

```
.
├── main.tf              # Main Terraform configuration file
├── variables.tf         # Input variables definition
├── outputs.tf           # Output values definition
├── versions.tf          # Terraform and provider versions
├── files/               # Additional files (SSH keys, etc.)
├── modules/
│   ├── network/         # Network module (VPC, subnet, router, security groups)
│   ├── compute/         # Compute module (instances and server configurations)
│   └── volumes/         # Volumes module (persistent volumes for instances)
```

## Prerequisites

- Terraform 1.10.5 or higher
- OpenStack credentials
- SSH key pair for accessing the instances

## Configuration

1. Create a `terraform.tfvars` file with your OpenStack credentials and configuration:

```hcl
openstack_auth_url    = "https://your-openstack-url:5000/v3"
openstack_user_name   = "your-username"
openstack_tenant_name = "your-project"
openstack_password    = "your-password"
openstack_region      = "your-region"

image_id              = "your-image-id"
ssh_public_key        = "ssh-rsa AAAA..."
```

You can update other variables as needed in this file.

## Usage

1. Initialize Terraform:

```
terraform init
```

2. Plan the deployment:

```
terraform plan
```

3. Apply the configuration:

```
terraform apply
```

4. After successful deployment, you'll get the IP addresses of the master and worker nodes.

## Using the tf8 Utility Script

For convenience, you can use the `tf8` script to simplify common operations:

```
./tf8 [COMMAND]
```

Available commands:
- `init` - Initialize Terraform working directory
- `plan` - Show execution plan
- `deploy` - Deploy the infrastructure (runs init, plan, and apply)
- `remove` or `destroy` - Remove all created resources
- `state` - List resources in the Terraform state
- `output` - Show output values
- `help` - Show help message

Example:
```
chmod +x tf8  # Make the script executable first
./tf8 deploy  # Deploy the complete infrastructure
```
## Cleaning Up

To destroy all resources:

```
terraform destroy
```

## Customization

You can customize the deployment by modifying the variables in `variables.tf` or by providing different values in your `terraform.tfvars` file.
