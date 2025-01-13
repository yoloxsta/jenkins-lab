pipeline {
    agent any
    environment {
        ImageRegistry = 'yolomurphy/sta'
        compose_service_name = "react-jenkins-docker"
        workspace = "/home/jenkins/project/react-jenkins-docker/"
    }
    stages {
        stage('Checkout Source') {
            steps {
                ws("${workspace}") {
                    checkout scm
                }
            }
        }
        stage("buildImage") {
            steps {
                script {
                    echo "Building Docker Image..."
                    sh "docker build -t ${ImageRegistry}:${BUILD_NUMBER} ."
                }
            }
        }
        stage("pushImage") {
            steps {
                script {
                    echo "Pushing Image to DockerHub..."
                    withCredentials([usernamePassword(credentialsId: 'docker-login', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                        sh '''
                            echo $PASS | docker login -u $USER --password-stdin
                            docker push ${ImageRegistry}:${BUILD_NUMBER}
                        '''
                    }
                }
            }
        }
        stage('Deploy to Minikube') {
            steps {
                    sh "kubectl apply -f k8s/deployment.yaml"
            }
        }
    }
    
}
