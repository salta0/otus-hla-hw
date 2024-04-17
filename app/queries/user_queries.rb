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
    first_name = params[:first_name]
    last_name = params[:last_name]
    like_sql = ["first_name like $1::#{columns[:first_name]}",
                "last_name like $2::#{columns[:last_name]}"].join(' AND ')
    values = [first_name, last_name].map { |v| "#{v}%" }
    complete_sql = <<-SQL
      SELECT * FROM #{table_name} WHERE #{like_sql} LIMIT #{limit}
    SQL

    DBConnection.exec_query(complete_sql, values)
  end
end
