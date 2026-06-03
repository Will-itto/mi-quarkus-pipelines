pipeline {
    agent {
        docker { 
            image 'maven:3.9-eclipse-temurin-17'
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
    
    environment {
        DOCKER_CRED = credentials('docker-hub-credentials')
    }
    
    stages {
        stage('Build & Deploy') {
            steps {
                sh '''
                    mvn clean package -DskipTests
                    docker build -t ${DOCKER_CRED_USR}/mi-quarkus-pipelines:latest .
                    echo ${DOCKER_CRED_PSW} | docker login -u ${DOCKER_CRED_USR} --password-stdin
                    docker push ${DOCKER_CRED_USR}/mi-quarkus-pipelines:latest
                '''
            }
        }
    }
}