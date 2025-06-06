# Azure DevOps Pipeline Project

This project implements a complete DevOps pipeline using Jenkins, Terraform, and Ansible to deploy a static website to Azure.

## Project Structure
```
.
├── Dockerfile              # Jenkins container configuration
├── Jenkinsfile            # Pipeline definition
├── terraform/             # Terraform configuration files
├── ansible/              # Ansible playbooks
└── scripts/              # Helper scripts
```

## Setup Instructions

1. Build Jenkins Docker container:
   ```bash
   docker build -t jenkins-devops .
   docker run -d -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock --name jenkins-devops jenkins-devops
   ```

2. Configure Jenkins:
   - Access Jenkins at http://localhost:8080
   - Install suggested plugins
   - Create pipeline job using the Jenkinsfile

3. Configure Credentials in Jenkins:
   - Azure Service Principal credentials
   - SSH key for VM access

4. Run the pipeline!

## Required Environment Variables
- AZURE_SUBSCRIPTION_ID
- AZURE_TENANT_ID
- AZURE_CLIENT_ID
- AZURE_CLIENT_SECRET 