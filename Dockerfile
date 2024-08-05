ARG DOCKER_REPO
FROM $DOCKER_REPO/alpine-adoptopenjdk:17.0.2_8-7-master

COPY ./target/message-integrations-*.jar /opt/narvar/message-integrations.jar

COPY docker-start.sh /opt/narvar/docker-start.sh

WORKDIR /opt/narvar

EXPOSE 8080

CMD ["sh", "/opt/narvar/docker-start.sh", "-j", "/opt/narvar/message-integrations.jar"]