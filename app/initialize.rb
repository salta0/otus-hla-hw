# frozen_string_literal: true

require 'yaml'
require 'sidekiq'
require_relative 'utils/red'

PG_MAIN_DB_CONF = YAML.load_file('config/database.yaml').fetch('main')
PG_REPLICA_DB_CONF = YAML.load_file('config/database.yaml').fetch('main')
REDIS_CONF = YAML.load_file('config/database.yaml').fetch('redis')
puts "redis://#{REDIS_CONF['host']}:#{REDIS_CONF['port']}"

Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{REDIS_CONF['host']}:#{REDIS_CONF['port']}" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{REDIS_CONF['host']}:#{REDIS_CONF['port']}" }
end

Dir[File.join(__dir__, 'jobs', '*.rb')].sort.each { |f| require f }
