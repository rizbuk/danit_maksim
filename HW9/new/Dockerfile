FROM maven:3.9.16-amazoncorretto-17-debian
RUN apt update  

WORKDIR /app
COPY . .
RUN mvn package
EXPOSE 8080
CMD ["java", "-jar", "target/spring-petclinic-4.0.0-SNAPSHOT.jar"]