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
      imagePullPolicy: IfNotPresent
      command:
        - cat
      tty: true
      volumeMounts:
        - mountPath: /home/jenkins/agent
          name: workspace-volume
          readOnly: false

    - name: docker
      image: docker:24.0-dind
      imagePullPolicy: IfNotPresent
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
      imagePullPolicy: IfNotPresent
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
        pollSCM('* * * * *') // vérifie les changements chaque minute
    }

    stages {
        stage('Test Python') {
            steps {
                container('python') {
                    script {
                        if (fileExists('requirements.txt')) {
                            sh 'pip
