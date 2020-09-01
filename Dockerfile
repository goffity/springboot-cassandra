FROM  maven:3-openjdk-11 as builder

LABEL maintaner="Goffirt Corleone"

WORKDIR /app

COPY . /app

# Build maven application
RUN mvn clean package

RUN mv target/*.jar app.jar

# Reduce image size
FROM openjdk:11-jdk-slim

RUN apk add --no-cache tzdata && \
        cp /usr/share/zoneinfo/Asia/Bangkok /etc/localtime && \
        echo "Asia/Bangkok" > /etc/timezone && \
        apk del tzdata

WORKDIR /app

COPY --from=builder /app/app.jar /app/app.jar

RUN mkdir -p /hava/upload

ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","app.jar"]