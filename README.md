# DevOps Project: Static Website Deployment using Terraform and Ansible

## 📄 Project Overview

This project showcases a fully automated DevOps pipeline for deploying a **static website** on an **Azure Virtual Machine** using **Terraform** for infrastructure provisioning and **Ansible** for configuration management.

* **Terraform** provisions Azure resources like VM, network interfaces, and security groups.
* **Ansible** installs and configures the NGINX web server, and deploys a static website.
* All project files are hosted on GitHub:
  [https://github.com/ArsalanAftab84/Devops\_Project](https://github.com/ArsalanAftab84/Devops_Project)

---

## 📁 Project Structure

```
Devops_Project/
├── terraform/
│   ├── main.tf          # Terraform main config file
│   ├── variables.tf     # Variables definition
│   ├── terraform.tfvars # Values for variables (user-defined)
│   └── outputs.tf       # Output values after provisioning
├── static-site/
│   └── index.html       # Static HTML site to be deployed
│   ├── hosts.ini        # Ansible inventory file with VM IP
│   └── site.yml         # Ansible playbook to install and configure NGINX
└── README.md            # This documentation
```

---

## ✅ Prerequisites

Before starting, ensure you have the following installed on your **local machine**:

* [Terraform](https://developer.hashicorp.com/terraform/downloads)
* [Git](https://git-scm.com/downloads)
* Azure CLI (optional but helpful)
* SSH Key Pair

To generate a key pair (if you don't have one):

```bash
ssh-keygen -t rsa -b 2048 -f ~/.ssh/azure_key
```

This will generate:

* `~/.ssh/azure_key` (private key)
* `~/.ssh/azure_key.pub` (public key to use in Terraform)

---

## ⏱ Step-by-Step Guide

### 1. 🔁 Clone the Repository

```bash
git clone https://github.com/ArsalanAftab84/Devops_Project.git
cd Devops_Project
```

### 2. ⚖️ Configure Terraform

```bash
cd terraform
```

Create a file named `terraform.tfvars`:

```hcl
resource_group_name = "myResourceGroup"
location            = "East US"
admin_username      = "azureuser"
admin_ssh_key       = "ssh-rsa AAAA...your_public_key_here"
```

> Replace `your_public_key_here` with the actual content of your public SSH public key (e.g. from `azure_key.pub`).

### 3. ⚡ Provision Azure Resources

```bash
terraform init
terraform apply
```

> Type `yes` when prompted.

---

### 4. 🔢 SSH into the Azure VM through VM's Public IP

```bash
ssh -i ~/.ssh/azure_key azureuser@PUBLIC_IP
```

### 5. 🧰 Install Ansible on the VM

Once inside the VM:

```bash
sudo apt update
sudo apt install -y ansible
```

---

### 6. 📦 Copy Project Files to Azure VM

Exit the VM and copy the project files from your local machine to the VM:

```bash
scp -i ~/.ssh/azure_key -r ~/path/to/Devops_Project azureuser@PUBLIC_IP:/home/azureuser/
```

> Adjust the path and IP as necessary.

---

### 7. 🔧 Update Ansible Inventory

```bash
cd ~/Devops_Project
```

Update `hosts.ini` with:

```ini
[web]
localhost ansible_connection=local
```

---

### 8. ⚙️ Run the Ansible Playbook

```bash
ansible-playbook -i hosts.ini site.yml
```

Ansible will:

* Install NGINX
* Copy your `index.html` file to `/var/www/html`
* Start and enable NGINX

---

### 9. 🔍 Verify Deployment

Open a browser and go to:

```
http://<PUBLIC_IP_FROM_OUTPUT>
```

You should see your static website!

---

## 🕹️ File-Level Explanation

### Terraform:

* **main.tf**: Defines Azure VM, VNet, NIC, NSG, and related resources
* **variables.tf**: Input variables to avoid hardcoding
* **terraform.tfvars**: Values for the variables (user-defined)
* **outputs.tf**: Displays the public IP after apply

### Ansible:

* **hosts.ini**: Lists inventory, here it's `localhost` as Ansible runs from inside the VM
* **site.yml**: Installs NGINX, deploys static site from `static-site/`

### Static Website:

* **index.html**: The HTML file served by NGINX on port 80

---

Happy Deploying! ✨
