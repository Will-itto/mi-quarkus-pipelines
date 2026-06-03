pipeline {
    agent any
    
    environment {
        DOCKER_CRED = credentials('docker-hub-credentials')
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build con Maven Wrapper') {
            steps {
                sh '''
                    chmod +x mvnw
                    ./mvnw clean package -DskipTests
                    ls -la target/quarkus-app/
                '''
            }
        }
        
        stage('Guardar Artefacto') {
            steps {
                archiveArtifacts artifacts: 'target/quarkus-app/**/*', allowEmptyArchive: true
            }
        }
    }
    
    post {
        success {
            echo '✅ Build completado exitosamente!'
            echo 'El JAR está disponible en los artefactos'
        }
    }
}