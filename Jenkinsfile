pipeline {
    agent any
    environment {
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
        stage('Docker Comopse Build') {
            steps {
                ws("${workspace}"){
                    sh "docker compose build --no-cache ${compose_service_name}"
                }
            }
        }
        stage('Docker Images Check') {
            steps {
                ws("${workspace}") {
                    // List the images and filter by service name
                    sh """
                        echo "Checking built images for ${compose_service_name}"
                        docker images | grep ${compose_service_name} || echo "No images found for ${compose_service_name}"
                    """
                }
            }
        }
        stage('Docker Comopse Up') {
            steps {
                ws("${workspace}"){
                    sh "docker compose up --no-deps -d ${compose_service_name}"
                }
            }
        }
    }
}
