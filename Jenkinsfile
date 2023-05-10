pipeline {

    agent any

    stages {

        // stage('git checkout'){

        //     steps{

        //         script{


        //         }
        //     }
        // }
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
            when {branch 'master'}
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