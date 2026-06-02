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