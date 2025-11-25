# Stage 1: Build the app with Maven (no wrapper)
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copy only pom.xml first (caches dependencies)
COPY pom.xml .
RUN mvn -B -DskipTests dependency:go-offline

# Now copy the rest of the source
COPY src ./src

# Build the application
RUN mvn -B -DskipTests clean package

# Stage 2: Run the Spring Boot JAR
FROM eclipse-temurin:17-jdk
WORKDIR /app

# Copy the built jar from the build stage
COPY --from=build /app/target/ems-backend-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
