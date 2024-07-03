# frozen_string_literal: true

module ThreadServices
  class CreateService
    class UniqueError < StandardError
      def message
        'Thread already exists'
      end
    end

    def initialize(from_id:, to_id:)
      @from_id = from_id
      @to_id = to_id
    end

    def self.call(from_id:, to_id:, body:)
      new(from_id:, to_id:, body:).call
    end

    def call
      thread = FetchService.new(from_id:, to_id:).call
      raise UniqueError unless thread[:result].nil?

      participants = [from_id, to_id].sort

      res = ThreadQueries.new(participants:).insert
      { success: true, result: res, error: nil }
    rescue UniqueError => e
      { success: false, result: nil, error: e }
    end

    private

    attr_reader :from_id, :to_id
  end
end
