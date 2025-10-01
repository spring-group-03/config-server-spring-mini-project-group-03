# ----- Stage 1: Build with Gradle -----
FROM gradle:8.7-jdk21 AS build

WORKDIR /app

# Copy Gradle config and wrapper files
COPY build.gradle settings.gradle gradlew ./
COPY gradle ./gradle

# Copy source code
COPY src ./src

# Build the project (skip tests for faster build)
RUN chmod +x ./gradlew && ./gradlew clean build -x test

# ----- Stage 2: Run with a minimal JDK -----
FROM eclipse-temurin:21-jre

WORKDIR /app

# Copy built JAR from previous stage
COPY --from=build /app/build/libs/*.jar app.jar

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]