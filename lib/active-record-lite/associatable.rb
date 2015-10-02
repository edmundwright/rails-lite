require 'active_support/inflector'

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @name = name
    @class_name = options[:class_name] || name.to_s.singularize.camelcase
    @foreign_key = options[:foreign_key] ||
                   "#{name.to_s.singularize.underscore}_id".to_sym
    @primary_key = options[:primary_key] || "id".to_sym
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @name = name
    @class_name = options[:class_name] || name.to_s.singularize.camelcase
    @foreign_key = options[:foreign_key] ||
                   "#{self_class_name.to_s.singularize.underscore}_id".to_sym
    @primary_key = options[:primary_key] || "id".to_sym
  end
end

module Associatable
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)
    assoc_options[name] = options

    primary_key_name = options.primary_key

    define_method(name) do
      foreign_key_value = send(options.foreign_key)

      options.model_class.where({primary_key_name => foreign_key_value}).first
    end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, to_s, options)
    assoc_options[name] = options

    define_method(name) do
      primary_key_value = send(options.primary_key)
      foreign_key_name = options.foreign_key

      options.model_class.where({foreign_key_name => primary_key_value})
    end
  end

  def has_one_through(name, through_name, source_name)
    through_options = assoc_options[through_name]
    source_options = through_options.model_class.assoc_options[source_name]

    define_method(name) do
      sql_result = DBConnection.execute(<<-SQL)
        SELECT
          source_table.*
        FROM
          #{source_options.table_name} AS source_table
        JOIN
          #{through_options.table_name} AS through_table
        ON
          source_table.#{source_options.primary_key} =
          through_table.#{source_options.foreign_key}
        WHERE
          through_table.#{through_options.primary_key} =
          #{send(through_options.foreign_key)}
      SQL

      source_options.model_class.parse_all(sql_result).first
    end
  end

  def assoc_options
    @assoc_options ||= {}
  end
end
