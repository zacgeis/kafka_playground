#!/bin/bash

until nc -z kafka 9092; do
  echo "Waiting for Kafka to start"
  sleep 0.5
done

ruby app.rb -p 8080 -o 0.0.0.0
