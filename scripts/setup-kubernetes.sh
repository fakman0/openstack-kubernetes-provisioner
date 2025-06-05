#!/bin/bash

set -e

# Script to run Kubernetes installation playbooks

# Get the scripts directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# For coloring
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Create temporary directory
mkdir -p "${PROJECT_ROOT}/tmp"
mkdir -p "${PROJECT_ROOT}/backup"

# Check if Python virtual environment exists
if [ ! -d "${PROJECT_ROOT}/.venv" ]; then
    echo -e "${YELLOW}[!] Python virtual environment not found. Setting it up...${NC}"
    "${SCRIPT_DIR}/generate_venv.sh"
fi

echo -e "${BLUE}[*] Activating Python virtual environment...${NC}"
source "${PROJECT_ROOT}/.venv/bin/activate"

# Check if ansible-playbook is available
if ! command -v ansible-playbook &> /dev/null; then
    echo -e "${RED}[!] ansible-playbook command not found. Make sure Ansible is installed correctly.${NC}"
    exit 1
fi

# Print Ansible version
echo -e "${BLUE}[*] Using Ansible version:${NC}"
ansible --version | head -n 1

# Print current working directory for debugging
echo -e "${BLUE}[*] Current working directory: $(pwd)${NC}"
echo -e "${BLUE}[*] Ansible configuration:${NC}"
echo -e "    - Project root: ${PROJECT_ROOT}"
echo -e "    - Inventory file: ${PROJECT_ROOT}/ansible/inventory/inventory.yaml"
echo -e "    - Playbook directory: ${PROJECT_ROOT}/ansible/playbooks"
echo -e "    - Roles directory: ${PROJECT_ROOT}/ansible/roles"

export ANSIBLE_CONFIG="${PROJECT_ROOT}/ansible/ansible.cfg"

echo -e "${BLUE}[*] Running Kubernetes prerequisites playbook...${NC}"
ansible-playbook -vv -i "${PROJECT_ROOT}/ansible/inventory/inventory.yaml" "${PROJECT_ROOT}/ansible/playbooks/kubernetes-prep.yml"

echo -e "${BLUE}[*] Running Kubernetes installation playbook...${NC}"
ansible-playbook -vv -i "${PROJECT_ROOT}/ansible/inventory/inventory.yaml" "${PROJECT_ROOT}/ansible/playbooks/kubernetes-install.yml"

echo -e "${BLUE}[*] Running Kubernetes post-installation playbook...${NC}"
ansible-playbook -vv -i "${PROJECT_ROOT}/ansible/inventory/inventory.yaml" "${PROJECT_ROOT}/ansible/playbooks/kubernetes-post.yml"

echo -e "${GREEN}[+] Kubernetes cluster installation completed${NC}"
echo -e "${YELLOW}[i] You can access your cluster using the kubeconfig file located at:${NC}"
echo -e "${YELLOW}    ${PROJECT_ROOT}/kubeconfig${NC}" 