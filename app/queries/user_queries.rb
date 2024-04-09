# frozen_string_literal: true

require_relative 'base_query'

class UserQueries < BaseQuery
  self.table_name = 'users'
  self.columns = {
    id: UUID_TYPE,
    password: VARCHAR_TYPE,
    access_token: UUID_TYPE,
    first_name: VARCHAR_TYPE,
    last_name: VARCHAR_TYPE,
    birthdate: DATE_TYPE,
    biography: TEXT_TYPE,
    city: VARCHAR_TYPE
  }
end
