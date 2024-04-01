FROM ruby:3.3.0
WORKDIR /app
COPY . .
COPY ./config/database.yaml.example config/database.yaml
RUN bundle install
EXPOSE 3000
CMD ["bundle", "exec", "puma", "-p", "3000"]
