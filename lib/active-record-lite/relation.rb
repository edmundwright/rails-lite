require_relative 'arrayable'

class Relation
  include Arrayable
  include Searchable

  def self.new_from_existing(options = {})
    existing_relation = options[:existing_relation]
    options[:class_to_create] = existing_relation.class_to_create

    [:where_fragments, :where_args, :join_fragments].each do |var|
      options[var] = existing_relation.send(var) + (options[var] || [])
    end

    new(options)
  end

  attr_reader :class_to_create, :where_fragments, :where_args, :join_fragments

  def initialize(options = {})
    raise "Need a class to start with!" unless options[:class_to_create]

    @class_to_create = options[:class_to_create]
    @where_fragments, @where_args = Relation.translate_where_options(options)
    @join_fragments = Relation.translate_join_options(options)
  end

  def load
    @results ||= evaluate
  end

  def to_a
    load
  end

  private

  def self.translate_where_options(options)
    fragments = (options[:where_fragments] || [])
    args = (options[:where_args] || [])

    if options[:where_hash]
      fragments << options[:where_hash].map { |col_name, _| "#{col_name} = ?" }
      args << options[:where_hash].values
    end

    [fragments, args]
  end

  def self.translate_join_options(options)
    fragments = (options[:join_fragments] || [])

    if options[:join_symbols]
      class_of_first_table = options[:class_to_create]

      options[:join_symbols].each do |assoc_name|
        assoc_options = class_of_first_table.assoc_options[assoc_name]
        fragments << build_join_fragment(class_of_first_table, assoc_options)

        class_of_first_table = assoc_options.model_class
      end
    end

    fragments
  end

  def self.build_join_fragment(class_of_first_table, assoc_options)
    if assoc_options.is_a?(BelongsToOptions)
      key_on_first_table = assoc_options.foreign_key
      key_on_second_table = assoc_options.primary_key
    else
      key_on_second_table = assoc_options.foreign_key
      key_on_first_table = assoc_options.primary_key
    end

    <<-SQL
      INNER JOIN
        #{assoc_options.table_name}
      ON
        #{class_of_first_table.table_name}.#{key_on_first_table}
        = #{assoc_options.table_name}.#{key_on_second_table}
    SQL
  end

  def evaluate
    if where_fragments.empty?
      where_section = ""
    else
      where_section = "WHERE " + where_fragments.join(" AND ")
    end

    sql_result = DBConnection.execute(<<-SQL, *where_args)
      SELECT
        #{class_to_create.table_name}.*
      FROM
        #{class_to_create.table_name}
      #{join_fragments.join(" ")}
      #{where_section}
    SQL

    class_to_create.parse_all(sql_result)
  end
end
