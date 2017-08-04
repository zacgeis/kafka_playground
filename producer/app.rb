require 'sinatra'
require 'kafka'

$stdout.sync = true

kafka = Kafka.new(
  seed_brokers: ['kafka:9092'],
  client_id: 'the-producer',
)

post '/send_event' do
  message = request.body.read
  kafka.deliver_message(message, topic: 'transactions')
  'success'
end
