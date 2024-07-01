# frozen_string_literal: true

require_relative 'base_query'

class MessageQueries < BaseQuery
  self.table_name = 'messages'
  self.columns = {
    id: INT_TYPE,
    thread_id: INT_TYPE,
    from_user_id: UUID_TYPE,
    to_user_id: UUID_TYPE,
    body: TEXT_TYPE,
    created_at: TIMESTAMP_TYPE
  }

  def list
    sql = <<-SQL
      SELECT * FROM #{table_name} WHERE thread_id = $1::#{columns[:thread_id]}
      ORDER BY created_at DESC LIMIT $2::int OFFSET $3::int
    SQL

    DBConnection.exec_query(:dialog, sql, [params[:thread_id], params[:limit], params[:offset]])
  end

  def insert
    column_list = params.keys.join(', ')
    values_list = params.keys.each_with_index.map { |name, i| "$#{i + 1}::#{columns[name]}" }.join(', ')
    sql = "INSERT INTO #{table_name} (#{column_list}) VALUES (#{values_list}) RETURNING *;"

    DBConnection.exec_query(:dialog, sql, params.values).first
  end
end
