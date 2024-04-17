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

  def search_by_name_prefix(limit)
    like_sql = ["lower(first_name) like lower($1::#{columns[:first_name]})",
                "lower(last_name) like lower($2::#{columns[:last_name]})"].join(' AND ')
    values = [params[:first_name], params[:last_name]].map { |v| "#{v}%" }
    complete_sql = <<-SQL
      SELECT #{params[:fields].join(',')} FROM #{table_name} WHERE #{like_sql} LIMIT #{limit}
    SQL

    DBConnection.exec_query(:read, complete_sql, values)
  end
end
