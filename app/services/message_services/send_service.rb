# frozen_string_literal: true

module MessageServices
  class SendService
    class EmptyBodyError < StandardError
      def message
        'Body is empty'
      end
    end

    def initialize(from_id:, to_id:, thread_id:, body:)
      @from_id = from_id
      @to_id = to_id
      @thread_id = thread_id
      @body = body
    end

    def self.call(from_id:, to_id:, thread_id:, body:)
      new(from_id:, to_id:, thread_id:, body:).call
    end

    def call
      raise EmptyBodyError if body.to_s.empty?

      res = MessageQueries.new(from_user_id: from_id, to_user_id: to_id, thread_id:, body:).insert
      { success: true, result: res, error: nil }
    rescue EmptyBodyError => e
      { success: false, result: nil, error: e }
    end

    private

    attr_reader :from_id, :to_id, :thread_id, :body
  end
end
