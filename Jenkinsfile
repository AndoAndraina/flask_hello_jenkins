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
  serviceAccountName: jenkins-sa   # <-- utilise le ServiceAccount créé
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
      command:
