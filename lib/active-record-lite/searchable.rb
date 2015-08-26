require_relative 'db_connection'

module Searchable
  def where(hash_or_fragment, *args)
    where_items = Searchable.parse_where_input(hash_or_fragment, args)

    if self.class == Relation
      Relation.new_from_existing({existing_relation: self}.merge(where_items))
    else
      Relation.new({class_to_create: self}.merge(where_items))
    end
  end

  def joins(*symbols_or_fragment)
    joins_items = Searchable.parse_joins_input(symbols_or_fragment)

    if self.class == Relation
      Relation.new_from_existing({existing_relation: self}.merge(joins_items))
    else
      Relation.new({class_to_create: self}.merge(joins_items))
    end
  end

  private

  def self.parse_where_input(hash_or_fragment, args)
    case hash_or_fragment
    when Hash
      raise "Additional args not expected with Hash!" unless args.empty?
      {where_hash: hash_or_fragment}
    when String
      {where_fragments: [hash_or_fragment], where_args: args}
    else
      raise "Wrong sort of argument provided!"
    end
  end

  def self.parse_joins_input(symbols_or_fragment)
    case symbols_or_fragment.first
    when Symbol
      {join_symbols: symbols_or_fragment}
    when String
      raise "Too many arguments!" if symbols_or_fragment.length != 1
      {join_fragments: [symbols_or_fragment.first]}
    else
      raise "Wrong sort of argument provided!"
    end
  end
end
