# frozen_string_literal: true

module UserServices
  require_relative '../queries/thread_queries'

  Dir[File.join(__dir__, 'thread_services', '*.rb')].sort.each { |f| require f }
end
