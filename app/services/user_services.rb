# frozen_string_literal: true

module UserServices
  require 'securerandom'
  require 'bcrypt'

  require_relative '../queries/user_queries'
  require_relative '../queries/users_friend_queries'

  Dir[File.join(__dir__, 'user_services', '*.rb')].sort.each { |f| require f }

  UUID_REGEX = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/
end
