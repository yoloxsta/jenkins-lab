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
                script {
                    echo "Deploying to Minikube..."

                    // Inject kubeconfig from Jenkins secret
                    withCredentials([string(credentialsId: 'kubeconfig', variable: 'KUBECONFIG_CONTENT')]) {
                        writeFile(file: '/home/jenkins/.kube/config', text: KUBECONFIG_CONTENT)
                    }

                    // Set the image in the deployment file (e.g., update the deployment YAML with the new image)
                    sh """
                        kubectl set image deployment/react-jenkins-docker react-jenkins-docker=${ImageRegistry}:${BUILD_NUMBER} --record
                    """
                    // Apply the updated deployment and service files from the repo
                    sh "kubectl apply -f k8s/deployment.yaml"
                }
            }
        }
    }
    
}
