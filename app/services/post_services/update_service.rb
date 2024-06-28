# frozen_string_literal: true

module PostServices
  class UpdateService
    class NotPermittedError < StandardError
      def message
        'Not permitted'
      end
    end

    class EmptyBodyError < StandardError
      def message
        'Body is empty'
      end
    end

    def initialize(post:, body:, user:)
      @post = post
      @user = user
      @body = body
    end

    def self.call(post:, body:, user:)
      new(post:, body:, user:).call
    end

    def call
      raise NotPermittedError unless user['id'] == post['user_id']
      raise NotPermittedError if body.to_s.empty?

      PostQueries.new(body:).update_by_id({ name: 'id', value: post['id'] })
      { success: true, result: body, error: nil }
    rescue NotPermittedError => e
      { success: false, result: nil, error: e }
    end

    private

    attr_reader :post, :body, :user
  end
end
