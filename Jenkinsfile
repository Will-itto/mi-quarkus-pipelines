pipeline {
    agent any
    tools {
        maven 'Maven-3.9'
        jdk 'JDK-17'
    }
    environment {
        DOCKER_IMAGE = 'mi-quarkus-pipelines'
        REGISTRY_CREDENTIALS = credentials('docker-hub-credentials')
    }
    stages {
        stage('Install Docker') {
            steps {
                sh 'apt-get update && apt-get install -y docker.io'
            }
        }
        stage('Check Tools') {
            steps {
                    sh 'echo "=== Java version ==="'
                    sh 'java -version || echo "Java not found"'
                    sh 'echo "=== Maven version ==="'
                    sh 'mvn -version || echo "Maven not found"'
                    sh 'echo "=== Docker version ==="'
                    sh 'docker --version || echo "Docker not found"'
                    sh 'echo "=== PATH ==="'
                    sh 'echo $PATH'
                }
            }
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Will-itto/mi-quarkus-pipelines.git', branch: 'main'
            }
        }
        stage('Test') {
            steps {
                sh './mvnw test'
            }
        }
        stage('Build & Package') {
            steps {
                sh './mvnw package -DskipTests'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE}:latest ."
            }
        }
        stage('Push to Docker Hub') {
            steps {
                sh """
                    echo ${REGISTRY_CREDENTIALS_PSW} | docker login -u ${REGISTRY_CREDENTIALS_USR} --password-stdin
                    docker tag ${DOCKER_IMAGE}:latest ${REGISTRY_CREDENTIALS_USR}/${DOCKER_IMAGE}:latest
                    docker push ${REGISTRY_CREDENTIALS_USR}/${DOCKER_IMAGE}:latest
                """
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}