# frozen_string_literal: true

require_relative 'base_query'

class ThreadQueries < BaseQuery
  self.table_name = 'threads'
  self.columns = {
    id: INT_TYPE,
    participants: ARRAY_UUID_TYPE,
    created_at: TIMESTAMP_TYPE
  }

  def fetch
    sql = <<-SQL
      SELECT * FROM #{table_name} WHERE participants = $1::#{columns[:participants]}
    SQL
    sql_array = params[:participants].sort.map { |id| "\"#{id}\"" }.join(',')
    DBConnection.exec_query(:dialog, sql, ["{#{sql_array}}"]).first
  end

  def insert
    sql_array = params[:participants].sort.map { |id| "\"#{id}\"" }.join(',')
    sql = "INSERT INTO #{table_name} (participants) VALUES ($1::#{columns[:participants]}) RETURNING *;"

    DBConnection.exec_query(:dialog, sql, ["{#{sql_array}}"]).first
  end
end
