FROM ruby:2.3.3

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev lsof netcat

RUN mkdir /consumer
WORKDIR /consumer

ADD Gemfile /consumer/Gemfile
ADD Gemfile.lock /consumer/Gemfile.lock

RUN bundle install

ADD . /consumer

EXPOSE 8080

CMD ["/bin/bash", "/consumer/start.sh"]
