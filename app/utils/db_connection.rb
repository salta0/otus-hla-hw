# frozen_string_literal: true

require 'pg'

class DBConnection
  DB_CONFS = {
    read: PG_REPLICA_DB_CONF,
    write: PG_MAIN_DB_CONF
  }.freeze

  def initialize(mode, sql, params)
    @mode = mode
    @sql = sql
    @params = params
  end

  def self.exec_query(mode, sql, params)
    new(mode, sql, params).exec_query
  end

  def exec_query
    res = connection.exec_params(sql, params)
    res.to_a
  ensure
    connection.finish unless connection.finished?
  end

  def connection
    @connection ||= PG.connect(conn_confs)
  end

  def conn_confs
    @conn_confs ||= DB_CONFS[mode]
  end

  protected

  attr_reader :mode, :sql, :params
end
