pipeline {
    agent {
        kubernetes {
            inheritFrom 'python-agent'
        }
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Install Dependencies') {
            steps {
                container('python') {
                    dir('flask-app') {
                        sh "pip install -r requirements.txt"
                    }
                }
            }
        }
        stage('Run Tests') {
            steps {
                container('python') {
                    dir('flask-app') {
                        sh "python test.py"
                    }
                }
            }
        }
    }
    post {
        success { echo "✅ Pipeline terminé avec succès" }
        failure { echo "❌ Pipeline échoué" }
    }
}
