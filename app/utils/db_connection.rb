# frozen_string_literal: true

require 'pg'

class DBConnection
  def self.exec_query(sql, params)
    new.exec_query(sql, params)
  end

  def exec_query(sql, params)
    res = connection.exec_params(sql, params)
    res.to_a
  ensure
    connection.finish unless connection.finished?
  end

  def connection
    @connection ||= PG.connect(PG_DB_CONF)
  end
end
