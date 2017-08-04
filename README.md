# Kafka Playground

The goal of this project is to provide a starting point for experimentation with Kafka, Ruby, Docker, and Docker Compose.

There are three main components:

**Kafka**

The Kafka portion is basically just a containerized version of Kafka that starts with a default "transactions" topic.

See `kafka/` for more details.

**The Consumer**

The Consumer is a ruby application that has two primary pieces of functionality. First, it subscribes to the Kafka topic "transactions".

It expects events to be in the following format: `COMMAND:{add_account,charge,credit} NAME:string VALUE:int`

As the events come in, it manipulates a sort of ledger structure in memory (see the code for more detail).

Second, it exposes an HTTP endpoint that returns the ledger - `curl localhost:4000`.

See `consumer/` for more details.

**The Producer**

The producer is a ruby application that exposes an HTTP endpoint. This HTTP endpoint allows you to publish events to the "transactions" topic.

Example: `curl -d 'credit zach 100' -X POST localhost:5000/send_event`

# Use

On a cpair:

```

> cd tech_playground

> docker-compose build
> docker-compose up

> curl localhost:4000
{}

> curl -d 'add_account zach 100' -X POST localhost:5000/send_event
success

> curl -d 'credit zach 100' -X POST localhost:5000/send_event
success

> curl localhost:4000
{"zach":200}


```

# Exploration Ideas

- Explore creating Kafka partitions
- Add new functionality
- Add multiple Kafka brokers
- Kill containers and bring them back while keeping others running
- Connect to Kafka from your host machine and write messages directly
- Add volume management in docker compose
