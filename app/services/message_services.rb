# frozen_string_literal: true

module MessageServices
  require_relative '../queries/message_queries'

  Dir[File.join(__dir__, 'message_services', '*.rb')].sort.each { |f| require f }
end
