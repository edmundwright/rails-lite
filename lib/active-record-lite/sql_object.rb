require_relative 'db_connection'
require_relative 'searchable'
require_relative 'relation'
require_relative 'associatable'
require 'active_support/inflector'

class SQLObject
  extend Searchable
  extend Associatable

  def self.columns
    column_names = DBConnection::execute2(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
      LIMIT 0
    SQL

    column_names.first.map(&:to_sym)
  end

  def self.finalize!
    columns.each do |column|
      define_method(column) do
        attributes[column]
      end

      define_method("#{column}=") do |value|
        attributes[column] = value
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name || to_s.tableize
  end

  def self.all
    sql_result = DBConnection::execute(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
    SQL

    parse_all(sql_result)
  end

  def self.parse_all(results)
    results.map do |result|
      result_with_symbol_keys = {}

      result.each do |key, value|
        result_with_symbol_keys[key.to_sym] = value
      end

      new(result_with_symbol_keys)
    end
  end

  def self.find(id)
    sql_result = DBConnection::execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        id = ?
    SQL

    parse_all(sql_result).first
  end

  def initialize(params = {})
    params.each do |column_name, value|
      if self.class.columns.include?(column_name)
        send("#{column_name}=", value)
      else
        raise "unknown attribute '#{column_name}'"
      end
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map { |col_name| send(col_name) }
  end

  def insert
    col_names = self.class.columns.join(", ")
    question_marks = (["?"] * self.class.columns.length).join(", ")

    DBConnection.execute(<<-SQL, *attribute_values)
      INSERT INTO
        #{self.class.table_name} (#{col_names})
      VALUES
        (#{question_marks})
    SQL

    self.id = DBConnection.last_insert_row_id
  end

  def update
    assignments = self.class.columns
                            .map { |col_name| "#{col_name} = ?" }
                            .join(", ")

    DBConnection.execute(<<-SQL, *attribute_values, id)
      UPDATE
        #{self.class.table_name}
      SET
        #{assignments}
      WHERE
        id = ?
    SQL
  end

  def save
    id.nil? ? insert : update
  end
end