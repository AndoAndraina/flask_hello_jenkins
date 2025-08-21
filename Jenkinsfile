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
"""
        }
    }
    stages { 
        stage('Test python') { 
            steps { 
                container('python') {
                    dir('flask-app') {   // 🔑 spécifie le sous-dossier où sont les fichiers
                        sh "pip install -r requirements.txt"
                        sh "python test.py"
                    }
                }
            } 
        } 
    } 
}
