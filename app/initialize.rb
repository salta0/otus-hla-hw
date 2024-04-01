# frozen_string_literal: true

require 'yaml'

PG_DB_CONF = YAML.load_file('config/database.yaml').fetch(ENV['RACK_ENV'] || 'development')
