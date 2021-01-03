FROM ruby:2.6.0

RUN apt-get update && apt-get install -y nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y mysql-client --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN mkdir /ventvert_backend
WORKDIR /ventvert_backend

ADD Gemfile /ventvert_backend/Gemfile
ADD Gemfile.lock /ventvert_backend/Gemfile.lock

RUN bundle install
ADD . /ventvert_backend