# OpenStack Kubernetes Provisioner

This project is designed to automatically create a highly available Kubernetes cluster on OpenStack. Infrastructure setup and Kubernetes configuration are fully automated using Terraform and Ansible.

## Project Purpose

This project aims to create a Kubernetes cluster in an OpenStack cloud environment with the following features:

- Multiple master nodes for high availability
- Scalable worker node structure
- RKE2 (Rancher Kubernetes Engine 2) based Kubernetes installation
- OpenStack Cloud Controller Manager integration
- Automated installation and configuration process

## Kubernetes Cluster Structure

The created Kubernetes cluster consists of the following components:

- **Master Nodes**: Servers running Kubernetes control plane components (API server, scheduler, controller manager). By default, 3 master nodes are created for high availability.
- **Worker Nodes**: Servers where application workloads run. Scalable according to needs.
- **Network Structure**: A private network and subnet are created on OpenStack. Floating IP address is provided for Kubernetes services.
- **Security**: Network traffic is controlled with OpenStack security groups.
- **Storage**: Separately sizeable storage areas for master and worker nodes.

## Installation Steps

### Prerequisites

- OpenStack account and access credentials
- Terraform (v1.0.0 or higher)
- Ansible (v2.9 or higher)
- Python 3.6 or higher

### 1. Infrastructure Setup with Terraform

1. Navigate to the Terraform directory:
   ```bash
   cd terraform
   ```

2. Create and edit the `terraform.tfvars` file:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```
   
   You need to edit the following information:
   - OpenStack authentication credentials
   - Network configuration
   - Server counts and specifications
   - SSH key information
   - Storage sizes

3. Create the infrastructure with Terraform:
   ```bash
   terraform init
   terraform apply
   ```

   When this process is complete, the `terraform_outputs.json` file will be created in the main directory.

### 2. Ansible Configuration

Return to the main directory and run the setup.sh script:

```bash
cd ..
./setup.sh all
```

This command performs the following operations:
- Creates a Python virtual environment and installs necessary dependencies
- Creates the Ansible inventory file using Terraform outputs
- Creates the Ansible configuration file

### 3. Kubernetes Installation

Navigate to the Ansible directory and run the playbooks in sequence:

```bash
cd ansible
```

1. Preparation for Kubernetes installation:
   ```bash
   ansible-playbook playbooks/kubernetes-prep.yml
   ```

2. Kubernetes installation:
   ```bash
   ansible-playbook playbooks/kubernetes-install.yml
   ```

3. Post-installation configuration:
   ```bash
   ansible-playbook playbooks/kubernetes-post.yml
   ```

## Post-Installation

When the installation is complete, the kubeconfig file needed to access the Kubernetes cluster will be created on the first master node. You can copy this file to your local machine and manage the cluster with `kubectl` commands.

To access the cluster:

```bash
scp ubuntu@<control_plane_floating_ip>:~/.kube/config ~/.kube/config
kubectl get nodes
```

## Customization

- Master and worker node counts can be adjusted from the `terraform.tfvars` file
- Hardware specifications (flavor) of nodes can be changed from the `terraform.tfvars` file
- Storage sizes can be adjusted from the `terraform.tfvars` file
- Network configuration can be customized from the `terraform.tfvars` file
