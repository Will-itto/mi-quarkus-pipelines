# Usa Maven directamente para compilar
FROM eclipse-temurin:17-jdk-alpine AS build

WORKDIR /app

# Copia solo el pom.xml primero (para cachear dependencias)
COPY pom.xml .

# Compila y descarga dependencias
RUN apk add --no-cache maven && \
    mvn dependency:go-offline -B

# Copia el código fuente
COPY src src

# Compila la aplicación
RUN mvn package -DskipTests

# Imagen final
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Copia el JAR generado
COPY --from=build /app/target/quarkus-app /app

EXPOSE 8080

CMD ["java", "-jar", "quarkus-run.jar"]