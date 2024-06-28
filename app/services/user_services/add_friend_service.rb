# frozen_string_literal: true

module UserServices
  class AddFriendService
    class AlreadyFriendError < StandardError
      def message
        'Already added'
      end
    end

    def initialize(user:, friend:)
      @user = user
      @friend = friend
    end

    def self.call(user:, friend:)
      new(user:, friend:).call
    end

    def call
      raise AlreadyFriendError if UsersFriendQueries.new(user_id: user['id'], friend_id: friend['id']).friend?

      UsersFriendQueries.new(user_id: user['id'], friend_id: friend['id']).insert

      { success: true, result: friend, error: nil }
    rescue AlreadyFriendError => e
      { success: false, result: nil, error: e }
    end

    private

    attr_reader :user, :friend
  end
end
