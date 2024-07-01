# frozen_string_literal: true

require_relative 'base_query'

class UsersFriendQueries < BaseQuery
  self.table_name = 'users_friends'
  self.columns = {
    user_id: UUID_TYPE,
    friend_id: UUID_TYPE,
    created_at: TIMESTAMP_TYPE
  }

  def list_subscribes
    friend_id = params[:friend_id]
    sql = <<-SQL
      SELECT * FROM #{table_name} WHERE friend_id = $1::#{columns[:friend_id]}
    SQL

    DBConnection.exec_query(:read, sql, [friend_id])
  end

  def delete
    user_id = params[:user_id]
    friend_id = params[:friend_id]
    sql = <<-SQL
      DELETE FROM #{table_name} WHERE user_id = $1::#{columns[:user_id]} AND friend_id = $2::#{columns[:friend_id]}
    SQL

    DBConnection.exec_query(:write, sql, [user_id, friend_id])
  end

  def friend?
    user_id = params[:user_id]
    friend_id = params[:friend_id]

    sql = <<-SQL
      SELECT * FROM #{table_name} WHERE user_id = $1::#{columns[:user_id]} AND friend_id = $2::#{columns[:friend_id]}
    SQL

    res = DBConnection.exec_query(:read, sql, [user_id, friend_id])
    res.any?
  end
end
