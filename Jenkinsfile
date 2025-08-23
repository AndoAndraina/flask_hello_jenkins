pipeline {
    agent {
        kubernetes {
            label 'jenkins-agent-my-app'
            serviceAccount 'jenkins-sa'
            defaultContainer 'python'
            yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: python
    image: python:3.7
    command:
    - cat
    tty: true
  - name: docker
    image: docker:24.0-dind
    command:
    - cat
    tty: true
    securityContext:
      privileged: true
    volumeMounts:
    - mountPath: /var/run/docker.sock
      name: docker-sock
  - name: kubectl
    image: lachlanevenson/k8s-kubectl:latest
    command:
    - cat
    tty: true
  volumes:
  - hostPath:
      path: /var/run/docker.sock
    name: docker-sock
"""
        }
    }

    environment {
        REGISTRY = "localhost:4000"
        IMAGE_NAME = "pythontest"
        KUBE_DEPLOYMENT = "./kubernetes/deployment.yaml"
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout([$class: 'GitSCM',
                          branches: [[name: '*/master']],
                          doGenerateSubmoduleConfigurations: false,
                          extensions: [],
                          userRemoteConfigs: [[url: 'git@github.com:AndoAndraina/flask_hello_jenkins.git', credentialsId: 'Ssh-git']]])
            }
        }

        stage('Test Python') {
            steps {
                container('python') {
                    script {
                        if (fileExists('flask_app/requirements.txt')) {
                            echo "requirements.txt found, installing dependencies..."
                            sh 'pip install -r flask_app/requirements.txt'
                        } else {
                            echo "requirements.txt absent, continuing..."
                        }

                        if (fileExists('flask_app/test.py')) {
                            echo "test.py found, running test..."
                            sh 'python flask_app/test.py'
                        } else {
                            echo "test.py absent, continuing..."
                        }
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                container('docker') {
                    sh "docker build -f flask_app/Dockerfile -t ${REGISTRY}/${IMAGE_NAME}:latest flask_app"
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                container('docker') {
                    sh "docker push ${REGISTRY}/${IMAGE_NAME}:latest"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                container('kubectl') {
                    sh "kubectl apply -f ${KUBE_DEPLOYMENT}"
                }
            }
        }
    }
}
