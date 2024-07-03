# frozen_string_literal: true

module ThreadServices
  class FetchService
    def initialize(from_id:, to_id:)
      @from_id = from_id
      @to_id = to_id
    end

    def self.call(from_id:, to_id:)
      new(from_id:, to_id:).call
    end

    def call
      participants = [from_id, to_id].sort
      res = ThreadQueries.new(participants:).fetch

      { success: true, result: res, error: nil }
    end

    private

    attr_reader :from_id, :to_id
  end
end
