# frozen_string_literal: true

module PostServices
  class ListService
    def initialize(user:)
      @user = user
    end

    def self.call(user:)
      new(user:).call
    end

    def call
      posts = PostQueries.new(user_id: user['id']).list

      { success: true, result: posts, error: nil }
    end

    private

    attr_reader :user
  end
end
