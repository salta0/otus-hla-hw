FROM ruby:3.3.0
WORKDIR /app
COPY . .
COPY ./config/database.yaml.example config/database.yaml
COPY ./config/sidekiq.yaml.example config/sidekiq.yaml
RUN bundle install
