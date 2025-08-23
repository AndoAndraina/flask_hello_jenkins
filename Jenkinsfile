pipeline {
    agent {
        kubernetes {
            label 'jenkins-agent-my-app'
            yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    component: ci
spec:
  containers:
    - name: python
      image: python:3.7
      command:
        - cat
      tty: true
      volumeMounts:
        - mountPath: /home/jenkins/agent
          name: workspace-volume
    - name: docker
      image: docker:24.0-dind
      securityContext:
        privileged: true
      command:
        - cat
      tty: true
      volumeMounts:
        - mountPath: /var/run/docker.sock
          name: docker-sock
        - mountPath: /home/jenkins/agent
          name: workspace-volume
    - name: kubectl
      image: lachlanevenson/k8s-kubectl:latest
      command:
        - cat
      tty: true
      volumeMounts:
        - mountPath: /home/jenkins/agent
          name: workspace-volume
  volumes:
    - name: docker-sock
      hostPath:
        path: /var/run/docker.sock
    - name: workspace-volume
      emptyDir: {}
"""
        }
    }

    triggers {
        pollSCM('* * * * *')
    }

    stages {
        stage('Test python') {
            steps {
                container('python') {
                    script {
                        if (fileExists('requirements.txt')) {
                            sh 'pip install -r requirements.txt'
                        } else {
                            echo 'requirements.txt absent, on continue'
                        }

                        if (fileExists('test.py')) {
                            sh 'python test.py'
                        } else {
                            echo 'test.py absent, on continue'
                        }
                    }
                }
            }
        }

        stage('Build image') {
            steps {
                container('docker') {
                    sh 'docker build -f flask_app/Dockerfile -t localhost:4000/pythontest:latest flask_app'
                    sh 'docker push localhost:4000/pythontest:latest'
                }
            }
        }

        stage('Deploy') {
            steps {
                container('kubectl') {
                    sh 'kubectl apply -f ./kubernetes/deployment.yaml'
                    sh 'kubectl apply -f ./kubernetes/service.yaml'
                }
            }
        }
    }
}
