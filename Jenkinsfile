pipeline {
    agent any
    
    environment {
        AZURE_SUBSCRIPTION_ID = credentials('AZURE_SUBSCRIPTION_ID')
        AZURE_CLIENT_ID = credentials('AZURE_CLIENT_ID')
        AZURE_CLIENT_SECRET = credentials('AZURE_CLIENT_SECRET')
        AZURE_TENANT_ID = credentials('AZURE_TENANT_ID')
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
                    }
                }
            }
        }
        
        stage('Wait for VM') {
            steps {
                sh 'sleep 60'  // Wait for VM to be fully ready
            }
        }
        
        stage('Configure VM with Ansible') {
            steps {
                dir('ansible') {
                    writeFile file: 'inventory.ini', text: "${env.VM_IP} ansible_user=adminuser ansible_ssh_private_key_file=~/.ssh/id_rsa"
                    sh 'ansible-playbook -i inventory.ini site.yml'
                }
            }
        }
    }
    
    post {
        failure {
            dir('terraform') {
                sh 'terraform destroy -auto-approve'
            }
        }
    }
} 