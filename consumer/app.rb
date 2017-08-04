require 'sinatra'
require 'kafka'
require 'json'

$stdout.sync = true

class AccountDataStore
  attr_reader :data

  def initialize
    @data = {}
  end

  def add_account(name, balance)
    @data[name] = balance
  end

  def credit(name, amount)
    @data[name] += amount
  end

  def charge(name, account)
    @data[name] -= amount
  end
end

class AccountEventConsumer
  def initialize(account_data_store)
    @account_data_store = account_data_store
    @kafka = nil
    @consumer = nil
  end

  def listen
    @kafka = Kafka.new(
      seed_brokers: ['kafka:9092'],
      client_id: 'the-consumer',
    )

    @consumer = @kafka.consumer(group_id: 'consumer-group-1')
    @consumer.subscribe('transactions')

    @consumer.each_message do |message|
      self.handle_message(message)
    end
  end

  def handle_message(message)
    puts message.topic, message.partition
    puts message.offset, message.key, message.value
    command, name, value = message.value.split(' ')
    amount = value.to_i
    if command == 'add_account'
      @account_data_store.add_account(name, amount)
    elsif command == 'credit'
      @account_data_store.credit(name, amount)
    elsif command == 'charge'
      @account_data_store.charge(name, amount)
    else
      raise 'command not found'
    end
  rescue Exception => e
    puts e
  end
end

account_data_store = AccountDataStore.new

Thread.new do
  event_consumer = AccountEventConsumer.new(account_data_store)
  event_consumer.listen
end

get '/' do
  content_type :json
  account_data_store.data.to_json
end
