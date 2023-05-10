pipeline {

    agent any
    stages {
        stage('Example') {
        steps {
        withCredentials([usernamePassword(credentialsId: 'my-creds', passwordVariable: 'MY_PASSWORD', usernameVariable: 'MY_USERNAME')]) {
          // set the environment variables on the machine
          sh 'echo "export MY_USERNAME=${MY_USERNAME}" >> ~/.bashrc'
          sh 'echo "export MY_PASSWORD=${MY_PASSWORD}" >> ~/.bashrc'
          sh 'source ~/.bashrc'
        }
        }
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
