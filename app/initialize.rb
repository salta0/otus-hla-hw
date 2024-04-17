# frozen_string_literal: true

require 'yaml'

PG_MAIN_DB_CONF = YAML.load_file('config/database.yaml').fetch('main')
PG_REPLICA_DB_CONF = YAML.load_file('config/database.yaml').fetch('replica')