# Use a Java 17 base image
FROM openjdk:17-jdk-slim
VOLUME /tmp
COPY target/PromethusGrafanademo-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]