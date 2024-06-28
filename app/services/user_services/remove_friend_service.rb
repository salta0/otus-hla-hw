# frozen_string_literal: true

module UserServices
  class RemoveFriendService
    def initialize(user:, friend:)
      @user = user
      @friend = friend
    end

    def self.call(user:, friend:)
      new(user:, friend:).call
    end

    def call
      UsersFriendQueries.new(user_id: user['id'], friend_id: friend['id']).delete

      { success: true, result: friend, error: nil }
    end

    private

    attr_reader :user, :friend
  end
end
