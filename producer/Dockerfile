FROM ruby:2.3.3

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev lsof netcat

RUN mkdir /producer
WORKDIR /producer

ADD Gemfile /producer/Gemfile
ADD Gemfile.lock /producer/Gemfile.lock

RUN bundle install

ADD . /producer

EXPOSE 8080

CMD ["/bin/bash", "/producer/start.sh"]
