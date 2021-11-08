FROM centos:8 as builder

RUN curl https://dlcdn.apache.org/kafka/3.0.0/kafka_2.13-3.0.0.tgz -o kafka_2.13-3.0.0.tgz
RUN tar -xvzf kafka_2.13-3.0.0.tgz

COPY resources/start-kafka.sh kafka_2.13-3.0.0

RUN chmod a+x kafka_2.13-3.0.0/start-kafka.sh

FROM openjdk:17-alpine

COPY --from=builder kafka_2.13-3.0.0 /opt/kafka 

WORKDIR /opt/kafka

ENTRYPOINT [ "./start-kafka.sh" ]