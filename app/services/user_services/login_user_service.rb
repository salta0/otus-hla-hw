# frozen_string_literal: true

module UserServices
  class LoginUserService
    class LoginErrors < StandardError
      def message
        'Invalid login or password'
      end
    end

    def initialize(id, password)
      @id = id
      @password = password
    end

    def self.call(id, password)
      new(id, password).call
    end

    def call
      check_id!
      user = fetch_user!
      check_password!(user['password'])
      token = generate_and_save_access_token!

      { success: true, result: token, error: nil }
    rescue LoginErrors => e
      { success: false, result: nil, error: e }
    end

    private

    attr_reader :id, :password

    def check_id!
      raise LoginErrors unless UUID_REGEX.match?(id)
    end

    def fetch_user!
      user = UserQueries.new(name: :id, value: id).find
      raise LoginErrors if user.nil?

      user
    end

    def check_password!(saved_password)
      raise LoginErrors if BCrypt::Password.new(saved_password) != password
    end

    def generate_and_save_access_token!
      access_token = SecureRandom.uuid
      UserQueries.new({ access_token: }).update_by_id({ name: 'id', value: id })
      access_token
    end
  end
end
