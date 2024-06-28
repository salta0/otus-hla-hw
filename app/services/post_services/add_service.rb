# frozen_string_literal: true

module PostServices
  class AddService
    class ValidationError < StandardError
    end

    class EmptyBodyError < ValidationError
      def message
        'Post body is empty'
      end
    end

    def initialize(user:, body:)
      @user = user
      @body = body
    end

    def self.call(user:, body:)
      new(user:, body:).call
    end

    def call
      raise EmptyBodyError if body.to_s.empty?

      post = PostQueries.new(user_id: user['id'], body:).insert

      AddPostJob.perform_async(user['id'], post['id'])

      { success: true, result: body, error: nil }
    rescue ValidationError => e
      { success: false, result: nil, error: e }
    end

    private

    attr_reader :user, :body
  end
end
