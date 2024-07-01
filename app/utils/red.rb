# frozen_string_literal: true

require 'redis'

class Red
  class << self
    def connection
      @connection ||= Redis.new(host: REDIS_CONF.fetch('host'))
    end

    def method_missing(method, *args)
      return connection.send(method, *args) if connection.respond_to?(method)

      super
    end

    def respond_to_missing?(method, *args)
      connection.respond_to_missing?(method, *args)
    end
  end
end
