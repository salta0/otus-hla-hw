# frozen_string_literal: true

require_relative '../utils/db_connection'

class BaseQuery
  VARCHAR_TYPE = :varchar
  TEXT_TYPE = :text
  UUID_TYPE = :uuid
  INT_TYPE = :int
  DATE_TYPE = :date
  TIMESTAMP_TYPE = :timestamp

  def initialize(params)
    @params = params
  end

  def find
    name = params[:name]
    value = params[:value]
    return nil unless columns.key?(name.to_sym)

    DBConnection.exec_query(
      :read, "SELECT * FROM #{table_name} WHERE #{name} = $1::#{columns[name]};",
      [value]
    ).first
  end

  def insert
    column_list = params.keys.join(', ')
    values_list = params.keys.each_with_index.map { |name, i| "$#{i + 1}::#{columns[name]}" }.join(', ')
    sql = "INSERT INTO #{table_name} (#{column_list}) VALUES (#{values_list}) RETURNING *;"
    DBConnection.exec_query(:write, sql, params.values).first
  end

  def update_by_id(id)
    sql = <<-SQL
      UPDATE #{table_name} SET #{build_assigment_list_for_update}#{' '}
      WHERE #{id[:name]} = $#{params.keys.length + 1}
    SQL
    DBConnection.exec_query(:write, sql, params.values.push(id[:value]))
  end

  protected

  attr_reader :params

  class << self
    attr_accessor :table_name, :columns
  end

  def table_name
    self.class.table_name
  end

  def columns
    self.class.columns
  end

  private

  def build_assigment_list_for_update
    params.keys.each_with_index.map { |k, i| "#{k} = $#{i + 1}::#{columns[k]}" }.join(', ')
  end
end
