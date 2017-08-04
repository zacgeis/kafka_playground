#!/bin/bash

/opt/kafka_2.11-0.10.1.0/bin/zookeeper-server-start.sh /opt/kafka_2.11-0.10.1.0/config/zookeeper.properties &
kill %1
while [ $(jobs | wc -l) -ne 0 ]; do
  echo "Waiting for Zookeeper to stop"
  sleep 0.5
done

echo "Clearing Zookeeper state"
ls /tmp
rm -rf /tmp/hsperfdata_root
rm -rf /tmp/kafka-logs
rm -rf /tmp/zookeeper
ls /tmp
echo "Zookeeper state cleared"

/opt/kafka_2.11-0.10.1.0/bin/zookeeper-server-start.sh /opt/kafka_2.11-0.10.1.0/config/zookeeper.properties &
/opt/kafka_2.11-0.10.1.0/bin/kafka-server-start.sh /opt/kafka_2.11-0.10.1.0/config/server.properties &

while [ $(lsof | grep TCP.*2181 | wc -l) -eq 0 ]; do
  echo "Waiting for Zookeeper to start"
  sleep 0.5
done

echo "Creating topics"
/opt/kafka_2.11-0.10.1.0/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic transactions

while true
do
  sleep 5
done
