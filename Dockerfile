ARG DOCKER_USER=rchauhan
# Use a minimal image as parent
FROM openjdk:8-jdk-alpine

# Environment variables
ENV TOMCAT_MAJOR=8 \
    TOMCAT_VERSION=8.5.100 \
    CATALINA_HOME=/opt/tomcat

# init
RUN apk -U upgrade --update && \
    apk add curl && \
    apk add ttf-dejavu

RUN mkdir -p /opt

# Add user and group
# RUN addgroup -S ${DOCKER_USER} && adduser -S ${DOCKER_USER} -G ${DOCKER_USER}

# install tomcat
RUN curl -jkSL -o /tmp/apache-tomcat.tar.gz http://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    gunzip /tmp/apache-tomcat.tar.gz && \
    tar -C /opt -xf /tmp/apache-tomcat.tar && \
    mv /opt/apache-tomcat-$TOMCAT_VERSION $CATALINA_HOME
    #ln -s /opt/apache-tomcat-$TOMCAT_VERSION $CATALINA_HOME

# cleanup to reduce image size
RUN apk del curl && \
    rm -rf /tmp/* /var/cache/apk/*

EXPOSE 8080

# set user
# USER ${DOCKER_USER}

ENTRYPOINT [ "/opt/tomcat/bin/catalina.sh", "run" ]

WORKDIR $CATALINA_HOME