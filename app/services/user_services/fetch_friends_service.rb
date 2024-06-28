# frozen_string_literal: true

module UserServices
  class FetchFriendsService
    class FetchByIdError < StandardError
    end

    def initialize(id)
      @id = id
    end

    def self.call(id)
      new(id).call
    end

    def call
      user = UserQueries.new({ user_id: id,
                               fields: %w[id first_name last_name birthdate biography city] }).fetch_friends
      { success: true, result: user, error: nil }
    end

    private

    attr_reader :id
  end
end
