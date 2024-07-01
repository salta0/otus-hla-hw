# frozen_string_literal: true

module PostServices
  require_relative '../queries/post_queries'

  Dir[File.join(__dir__, 'post_services', '*.rb')].sort.each { |f| require f }
end
