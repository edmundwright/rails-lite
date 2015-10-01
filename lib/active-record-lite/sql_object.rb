require_relative 'db_connection'
require_relative 'searchable'
require_relative 'relation'
require_relative 'associatable'
require 'active_support/inflector'
require 'byebug'

class SQLObject
  extend Searchable
  extend Associatable

  attr_reader :errors

  def self.validations
    @validations
  end

  def self.columns
    column_names = DBConnection.execute(<<-SQL).fields
      SELECT
        *
      FROM
        #{table_name}
      LIMIT 0
    SQL

    column_names.map(&:to_sym)
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

  def self.validates(*columns, restrictions)
    @validations = Hash.new { |hash, key| hash[key] = {} } unless @validations
    columns.each do |column|
      @validations[column].merge!(restrictions)
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
    parsed = []

    results.each do |result|
      result_with_symbol_keys = {}

      result.each do |key, value|
        result_with_symbol_keys[key.to_sym] = value
      end

      parsed << new(result_with_symbol_keys)
    end

    parsed
  end

  def self.find(id)
    id = id.to_i
    sql_result = DBConnection::execute(<<-SQL, [id])
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
    @errors = []
    params.each do |column_name, value|
      column_name = column_name.to_sym
      if self.class.columns.include?(column_name)
        send("#{column_name}=", value)
      elsif self.class.method_defined?("#{column_name}=".to_sym)
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
    col_names = self.class.columns.drop(1).join(", ")
    question_marks = (["?"] * (self.class.columns.length - 1)).join(", ")

    result_of_insert = DBConnection.execute(<<-SQL, attribute_values.drop(1))
      INSERT INTO
        #{self.class.table_name} (#{col_names})
      VALUES
        (#{question_marks})
      RETURNING
        id
    SQL

    self.id = result_of_insert.values[0][0].to_i
  end

  def update
    assignments = self.class.columns
                            .map { |col_name| "#{col_name} = ?" }
                            .join(", ")

    DBConnection.execute(<<-SQL, attribute_values << id)
      UPDATE
        #{self.class.table_name}
      SET
        #{assignments}
      WHERE
        id = ?
    SQL
  end

  def save
    check_validations
    return false unless @errors.empty?

    id.nil? ? insert : update
  end

  def check_validations
    self.class.validations.each do |column, restrictions|
      restrictions.each do |restriction, value|
        case restriction
        when :presence
          if value==true
            @errors << "#{column} can't be blank" if send(column).empty?
          end
        when :length
          if value[:minimum] && send(column) && send(column).length < value[:minimum]
            @errors << "#{column} must be at least #{value[:minimum]} characters"
          elsif send(column).nil? && !value[:allow_nil]
            @errors << "#{column} must not be nil"
          end
        end
      end
    end
  end
end
