# frozen_string_literal: true

module UserServices
  class FetchByIdService
    class FetchByIdError < StandardError
    end

    def initialize(id)
      @id = id
    end

    def self.call(id)
      new(id).call
    end

    def call
      raise FetchByIdError, 'Invalid id' unless UUID_REGEX.match?(id)

      user = UserQueries.new({ name: :id, value: id }).find
      { success: true, result: user, error: nil }
    rescue FetchByIdError => e
      { success: false, result: nil, error: e }
    end

    private

    attr_reader :id
  end
end
