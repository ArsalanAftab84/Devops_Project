pipeline {
    agent any
    
    environment {
        AZURE_SUBSCRIPTION_ID = credentials('AZURE_SUBSCRIPTION_ID')
        AZURE_CLIENT_ID = credentials('AZURE_CLIENT_ID')
        AZURE_CLIENT_SECRET = credentials('AZURE_CLIENT_SECRET')
        AZURE_TENANT_ID = credentials('AZURE_TENANT_ID')
        SSH_PRIVATE_KEY = credentials('YOUR_SSH_PRIVATE_KEY_CREDENTIAL_ID')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }
        
        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }
        
        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
        
        stage('Get VM IP') {
            steps {
                dir('terraform') {
                    script {
                        env.VM_IP = sh(
                            script: 'terraform output -raw public_ip',
                            returnStdout: true
                        ).trim()
                        echo "VM IP is: ${env.VM_IP}"
                    }
                }
            }
        }
        
        stage('Wait for VM') {
            steps {
                echo 'Waiting 60 seconds for VM to be ready...'
                sh 'sleep 60'  
            }
        }
        
        stage('Prepare SSH Key') {
            steps {
                script {
                    // Write SSH private key to a file for Ansible to use
                    writeFile file: 'id_rsa', text: env.SSH_PRIVATE_KEY
                    sh 'chmod 600 id_rsa'
                }
            }
        }
        
        stage('Configure VM with Ansible') {
            steps {
                script {
                    // Create inventory file dynamically using VM_IP and SSH key path
                    def inventoryContent = """[web]
${env.VM_IP} ansible_user=azureuser ansible_ssh_private_key_file=${pwd()}/id_rsa
"""
                    writeFile file: 'hosts.ini', text: inventoryContent
                }
                // Run ansible playbook from root directory
                sh 'ansible-playbook -i hosts.ini site.yml'
            }
        }
    }
    
    post {
        failure {
            echo "Pipeline failed! Destroying resources..."
            dir('terraform') {
                sh 'terraform destroy -auto-approve'
            }
        }
    }
}
