# frozen_string_literal: true

require_relative 'base_query'

class PostQueries < BaseQuery
  self.table_name = 'posts'
  self.columns = {
    id: INT_TYPE,
    user_id: UUID_TYPE,
    body: TEXT_TYPE,
    created_at: TIMESTAMP_TYPE
  }

  def list
    sql = <<-SQL
      SELECT * FROM #{table_name} WHERE user_id = $1::#{columns[:user_id]}
    SQL

    DBConnection.exec_query(:read, sql, [params[:user_id]])
  end

  def feed
    users_friends_table = UsersFriendQueries.table_name
    users_friends_columns = UsersFriendQueries.columns
    sql = <<-SQL
      SELECT #{table_name}.id, #{table_name}.body, #{table_name}.user_id, #{table_name}.created_at FROM #{table_name}
      LEFT JOIN #{users_friends_table} ON
      (#{table_name}.user_id = #{users_friends_table}.friend_id)
      WHERE #{users_friends_table}.user_id = $1::#{users_friends_columns[:user_id]}
      ORDER BY #{table_name}.created_at DESC LIMIT 1000
    SQL

    DBConnection.exec_query(:read, sql, [params[:user_id]])
  end

  def delete
    sql = <<-SQL
      DELETE FROM #{table_name} WHERE id = $1::#{columns[:id]}
    SQL

    DBConnection.exec_query(:write, sql, [params[:id]])
  end
end
