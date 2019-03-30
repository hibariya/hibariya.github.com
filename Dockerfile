FROM ruby:2.6.2-slim

RUN apt-get update \
      && apt-get install -y --no-install-recommends make gcc g++ \
      && rm -rf /var/lib/apt/lists/*

RUN gem install bundler --no-document
