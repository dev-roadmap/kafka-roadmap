#!/bin/sh

# Optional ENV variables:
# * ADVERTISED_HOST: the external ip for the container, e.g. `docker-machine ip \`docker-machine active\``
# * ADVERTISED_PORT: the external port for Kafka, e.g. 9092
# * ZK_CHROOT: the zookeeper chroot that's used by Kafka (without / prefix), e.g. "kafka"
# * LOG_RETENTION_HOURS: the minimum age of a log file in hours to be eligible for deletion (default is 168, for 1 week)
# * LOG_RETENTION_BYTES: configure the size at which segments are pruned from the log, (default is 1073741824, for 1GB)
# * NUM_PARTITIONS: configure the default number of log partitions per topic

# Set the external host and port
if [ ! -z "$ADVERTISED_HOST" ]; then
    echo "advertised host: $ADVERTISED_HOST"
    if grep -q "^advertised.host.name" ./config/server.properties; then
        sed -r -i "s/#(advertised.host.name)=(.*)/\1=$ADVERTISED_HOST/g" ./config/server.properties
    else
        echo "" >> ./config/server.properties
        echo "advertised.host.name=$ADVERTISED_HOST" >> ./config/server.properties
    fi
fi
if [ ! -z "$ADVERTISED_PORT" ]; then
    echo "advertised port: $ADVERTISED_PORT"
    if grep -q "^advertised.port" ./config/server.properties; then
        sed -r -i "s/#(advertised.port)=(.*)/\1=$ADVERTISED_PORT/g" ./config/server.properties
    else
        echo "" >> ./config/server.properties
        echo "advertised.port=$ADVERTISED_PORT" >> ./config/server.properties
    fi
fi

# Set the zookeeper chroot
if [ ! -z "$ZK_CHROOT" ]; then
    # configure kafka
    sed -r -i "s/(zookeeper.connect)=(.*)/\1=$ZK_CHROOT/g" ./config/server.properties
fi

# Allow specification of log retention policies
if [ ! -z "$LOG_RETENTION_HOURS" ]; then
    echo "log retention hours: $LOG_RETENTION_HOURS"
    sed -r -i "s/(log.retention.hours)=(.*)/\1=$LOG_RETENTION_HOURS/g" ./config/server.properties
fi
if [ ! -z "$LOG_RETENTION_BYTES" ]; then
    echo "log retention bytes: $LOG_RETENTION_BYTES"
    sed -r -i "s/#(log.retention.bytes)=(.*)/\1=$LOG_RETENTION_BYTES/g" ./config/server.properties
fi

# Configure the default number of log partitions per topic
if [ ! -z "$NUM_PARTITIONS" ]; then
    echo "default number of partition: $NUM_PARTITIONS"
    sed -r -i "s/(num.partitions)=(.*)/\1=$NUM_PARTITIONS/g" ./config/server.properties
fi

# Enable/disable auto creation of topics
if [ ! -z "$AUTO_CREATE_TOPICS" ]; then
    echo "auto.create.topics.enable: $AUTO_CREATE_TOPICS"
    echo "auto.create.topics.enable=$AUTO_CREATE_TOPICS" >> ./config/server.properties
fi

# Run Kafka
sed -i -e '1s:#!/bin/bash:#!/bin/sh:' bin/*.sh
./bin/kafka-server-start.sh ./config/server.properties
