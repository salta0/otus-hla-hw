# frozen_string_literal: true

module PostServices
  class DeleteService
    class NotPermittedError < StandardError
      def message
        'Not permitted'
      end
    end

    def initialize(post:, user:)
      @post = post
      @user = user
    end

    def self.call(post:, user:)
      new(post:, user:).call
    end

    def call
      raise NotPermittedError unless user['id'] == post['user_id']

      PostQueries.new(id: post['id']).delete
      { success: true, result: post, error: nil }
    rescue NotPermittedError => e
      { success: false, result: nil, error: e }
    end

    private

    attr_reader :post, :user
  end
end
