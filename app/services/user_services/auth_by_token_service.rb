# frozen_string_literal: true

module UserServices
  class AuthByTokenService
    class AuthByTokenError < StandardError
    end

    def initialize(token)
      @token = token
    end

    def self.call(token)
      new(token).call
    end

    def call
      raise AuthByTokenError, 'Auth failed' unless UUID_REGEX.match?(token)

      user = UserQueries.new({ name: :access_token, value: token }).find
      raise AuthByTokenError, 'Auth failed' if user.nil?

      { success: true, result: user, error: nil }
    rescue AuthByTokenError => e
      { success: false, result: nil, error: e }
    end

    private

    attr_reader :token
  end
end
