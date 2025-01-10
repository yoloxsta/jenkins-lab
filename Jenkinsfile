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
                dependencyCheck additionalArguments: '--format HTML', odcInstallation: 'owasp'
                
            }
        }

        stage('OWASP Dependency-Check Vulnerabilities') {
            steps {
                dependencyCheck additionalArguments: ''' 
                            -o './'
                            -s './'
                            -f 'ALL' 
                            --prettyPrint''', odcInstallation: 'owasp'
                
                dependencyCheckPublisher pattern: 'dependency-check-report.xml'
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

