pipeline {

    agent any
    environment {
        aws_access_key_id = "aws_access_key_id"
        aws_secret_access_key = "aws_secret_access_key"
    }
    stages {

        stage('git checkout'){
            
            steps {
                git branch: 'main', url: 'https://github.com/hesblac/terraform-demo-serverup.git'
            }
        }
        stage('Terraform init'){

            steps {

                script{
                    dir('.'){

                        sh "terraform init"
                    }

                }
            }
        }
        stage('Terraform plan'){

            steps {

                dir('.'){

                   sh "terraform plan"
                }

            }
        }
        stage('Terraform approval'){
            when {branch 'production'}
            steps {

                script{
                    waitUntil {
                        fileExists('dummyfile')
                    }

                }
            }
        }
        stage('Terraform apply'){

            steps {

                script{
                    dir('.'){

                        sh "terraform apply --auto-approve"
                    }

                }
            }
        }

    }
}
