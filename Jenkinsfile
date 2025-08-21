pipeline {
    agent {
        kubernetes {
            inheritFrom 'python-agent'   // nom du pod template défini dans Jenkins
        }
    }

    stages {
        stage('Checkout') {
            steps {
                echo "=== Récupération du code depuis Git ==="
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                container('python') {
                    echo "=== Installation des dépendances Python ==="
                    dir('flask-app') {
                        sh "pip install -r requirements.txt"
                    }
                }
            }
        }

        stage('Run Tests') {
            steps {
                container('python') {
                    echo "=== Lancement des tests Python ==="
                    dir('flask-app') {
                        sh "python test.py"
                    }
                }
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline terminé avec succès"
        }
        failure {
            echo "❌ Pipeline échoué, vérifier les logs"
        }
    }
}
