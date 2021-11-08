FROM centos:8 as builder

RUN curl https://dlcdn.apache.org/zookeeper/zookeeper-3.7.0/apache-zookeeper-3.7.0-bin.tar.gz -o apache-zookeeper-3.7.0-bin.tar.gz
RUN tar -xvzf apache-zookeeper-3.7.0-bin.tar.gz
RUN cp ./apache-zookeeper-3.7.0-bin/conf/zoo_sample.cfg ./apache-zookeeper-3.7.0-bin/conf/zoo.cfg

FROM openjdk:17-alpine

RUN apk update && apk upgrade && apk add bash

COPY --from=builder apache-zookeeper-3.7.0-bin /opt/zookeeper

WORKDIR /opt/zookeeper

ENTRYPOINT [ "./bin/zkServer.sh", "--config", "conf", "start-foreground" ]