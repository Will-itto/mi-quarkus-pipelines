pipeline {
    agent any
    
    tools {
        maven 'Maven-3.9'
        jdk 'JDK-17'
    }
    
    environment {
        // Credenciales de Docker Hub
        DOCKER_CRED = credentials('docker-hub-credentials')
        // Nombre de la imagen
        IMAGE_NAME = "${DOCKER_CRED_USR}/mi-quarkus-pipelines"
        IMAGE_TAG = "latest"
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
                echo "Código clonado exitosamente"
            }
        }
        
        stage('Verificar Herramientas') {
            steps {
                sh '''
                    echo "=== Versiones de herramientas ==="
                    java -version
                    mvn -version
                    docker --version
                    echo "================================"
                '''
            }
        }
        
        stage('Compilar Proyecto') {
            steps {
                sh 'mvn clean compile -DskipTests'
            }
            post {
                success {
                    echo "Compilación exitosa"
                }
                failure {
                    echo "Error en la compilación"
                }
            }
        }
        
        stage('Ejecutar Tests') {
            steps {
                sh 'mvn test'
            }
            post {
                success {
                    echo "Todos los tests pasaron"
                }
                failure {
                    echo "Algunos tests fallaron"
                }
            }
        }
        
        stage('Empaquetar Aplicación') {
            steps {
                sh 'mvn package -DskipTests'
            }
            post {
                success {
                    echo "JAR generado en target/"
                }
            }
        }
        
        stage('Construir Imagen Docker') {
            steps {
                sh '''
                    echo "Construyendo imagen: ${IMAGE_NAME}:${IMAGE_TAG}"
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                    docker images | grep mi-quarkus-pipelines
                '''
            }
        }
        
        stage('Probar Contenedor Localmente') {
            steps {
                sh '''
                    # Detener contenedor anterior si existe
                    docker stop mi-app-test || true
                    docker rm mi-app-test || true
                    
                    # Ejecutar contenedor de prueba
                    docker run -d --name mi-app-test -p 8081:8080 ${IMAGE_NAME}:${IMAGE_TAG}
                    
                    # Esperar a que inicie
                    sleep 10
                    
                    # Probar el endpoint
                    curl -f http://localhost:8081/hello || exit 1
                    
                    # Limpiar
                    docker stop mi-app-test
                    docker rm mi-app-test
                    
                    echo "Contenedor probado exitosamente"
                '''
            }
        }
        
        stage('Login a Docker Hub') {
            steps {
                sh '''
                    echo ${DOCKER_CRED_PSW} | docker login -u ${DOCKER_CRED_USR} --password-stdin
                    echo "Login exitoso a Docker Hub"
                '''
            }
        }
        
        stage('Subir Imagen a Docker Hub') {
            steps {
                sh '''
                    echo "Subiendo imagen a Docker Hub..."
                    docker push ${IMAGE_NAME}:${IMAGE_TAG}
                    echo "Imagen subida exitosamente: ${IMAGE_NAME}:${IMAGE_TAG}"
                '''
            }
        }
        
        stage('Limpiar Recursos Locales') {
            steps {
                sh '''
                    # Limpiar imágenes no utilizadas
                    docker image prune -f
                    echo "Limpieza completada"
                '''
            }
        }
    }
    
    post {
        always {
            echo "Pipeline finalizado"
            // Limpiar workspace
            cleanWs()
        }
        success {
            echo '''
                🎉 PIPELINE EXITOSO 🎉
                
                Imagen disponible en Docker Hub:
                ${IMAGE_NAME}:${IMAGE_TAG}
                
                Para descargar y ejecutar:
                docker pull ${IMAGE_NAME}:${IMAGE_TAG}
                docker run -p 8080:8080 ${IMAGE_NAME}:${IMAGE_TAG}
            '''
        }
        failure {
            echo '''
                ❌ PIPELINE FALLIDO ❌
                
                Revisa los logs para identificar el error.
                Errores comunes:
                - Credenciales de Docker Hub incorrectas
                - Tests fallidos
                - Problemas de compilación
            '''
        }
    }
}