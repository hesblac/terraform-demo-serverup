pipeline {

    agent any
    environment{

        ACCESS_KEY = credentials('aws_access_key_id')
        SECRET_KEY = credentials('aws_secret_access_key')
    }
    stages {
        stage('git checkout'){
            
            steps {
                git branch: 'main', url: 'https://github.com/hesblac/terraform-demo-serverup.git'
            }
        }
        stage('add aws auth'){

            steps{
                sh """
                    aws configure set aws_access_key_id "$ACCESS_KEY"
                    aws configure set aws_secret_access_key "$SECRET_KEY"
                    aws configure set regiion ""
                """
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
