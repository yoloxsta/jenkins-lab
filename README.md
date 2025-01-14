# Getting Started with Create React App

This project was bootstrapped with [Create React App](https://github.com/facebook/create-react-app).

## Available Scripts

In the project directory, you can run:

### `npm start`

Runs the app in the development mode.\
Open [http://localhost:3000](http://localhost:3000) to view it in your browser.

The page will reload when you make changes.\
You may also see any lint errors in the console.

### `npm test`

Launches the test runner in the interactive watch mode.\
See the section about [running tests](https://facebook.github.io/create-react-app/docs/running-tests) for more information.

### `npm run build`

Builds the app for production to the `build` folder.\
It correctly bundles React in production mode and optimizes the build for the best performance.

The build is minified and the filenames include the hashes.\
Your app is ready to be deployed!

See the section about [deployment](https://facebook.github.io/create-react-app/docs/deployment) for more information.

### `npm run eject`

**Note: this is a one-way operation. Once you `eject`, you can't go back!**

If you aren't satisfied with the build tool and configuration choices, you can `eject` at any time. This command will remove the single build dependency from your project.

Instead, it will copy all the configuration files and the transitive dependencies (webpack, Babel, ESLint, etc) right into your project so you have full control over them. All of the commands except `eject` will still work, but they will point to the copied scripts so you can tweak them. At this point you're on your own.

You don't have to ever use `eject`. The curated feature set is suitable for small and middle deployments, and you shouldn't feel obligated to use this feature. However we understand that this tool wouldn't be useful if you couldn't customize it when you are ready for it.

## Learn More

You can learn more in the [Create React App documentation](https://facebook.github.io/create-react-app/docs/getting-started).

To learn React, check out the [React documentation](https://reactjs.org/).

### Code Splitting

This section has moved here: [https://facebook.github.io/create-react-app/docs/code-splitting](https://facebook.github.io/create-react-app/docs/code-splitting)

### Analyzing the Bundle Size

This section has moved here: [https://facebook.github.io/create-react-app/docs/analyzing-the-bundle-size](https://facebook.github.io/create-react-app/docs/analyzing-the-bundle-size)

### Making a Progressive Web App

This section has moved here: [https://facebook.github.io/create-react-app/docs/making-a-progressive-web-app](https://facebook.github.io/create-react-app/docs/making-a-progressive-web-app)

### Advanced Configuration

This section has moved here: [https://facebook.github.io/create-react-app/docs/advanced-configuration](https://facebook.github.io/create-react-app/docs/advanced-configuration)

### Deployment

This section has moved here: [https://facebook.github.io/create-react-app/docs/deployment](https://facebook.github.io/create-react-app/docs/deployment)

### `npm run build` fails to minify

This section has moved here: [https://facebook.github.io/create-react-app/docs/troubleshooting#npm-run-build-fails-to-minify](https://facebook.github.io/create-react-app/docs/troubleshooting#npm-run-build-fails-to-minify)

######################################################

```
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
        stage('Dependency-check') {
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
```
###Remote cluster
`https://www.fosstechnix.com/integrate-remote-kubernetes-cluster-with-jenkins/`

### Assignment 2

```
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
    }
}
```
#############################

###For Token
`https://medium.com/@devayanthakur/minikube-configure-jenkins-kubernetes-plugin-25eb804d0dec`

#######################
##Fix

```
sudo -u jenkins -i
cat /home/ubuntu/.minikube/profiles/minikube/client.crt
cat /home/ubuntu/.minikube/profiles/minikube/client.key
sudo usermod -aG ubuntu jenkins
groups jenkins
sudo chmod -R 755 /home/ubuntu/.minikube
sudo chmod 644 /home/ubuntu/.minikube/profiles/minikube/client.crt
sudo chmod 644 /home/ubuntu/.minikube/profiles/minikube/client.key

###Check
sudo -u jenkins -i
ls -l /home/ubuntu/.minikube/profiles/minikube/
cat /home/ubuntu/.minikube/profiles/minikube/client.crt
cat /home/ubuntu/.minikube/profiles/minikube/client.key
exit
```