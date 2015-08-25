require 'uri'

class Params
  def params
    @params ||= {}
  end

  def initialize(req, route_params = {})
    params.merge!(route_params)
          .merge!(parse_www_encoded_form(req.query_string))
          .merge!(parse_www_encoded_form(req.body))
  end

  def [](key)
    params[key.to_sym] || params[key.to_s]
  end

  def to_s
    params.to_s
  end

  class AttributeNotFoundError < ArgumentError; end;

  private

  def parse_www_encoded_form(www_encoded_form)
    result = {}

    URI::decode_www_form(www_encoded_form.to_s).each do |key, value|
      nested_keys = parse_key(key)

      current_level = result

      nested_keys[0...-1].each do |nested_key|
        current_level[nested_key] ||= {}
        current_level = current_level[nested_key]
      end

      current_level[nested_keys.last] = value
    end

    result
  end

  def parse_key(key)
    key.split(/\]\[|\]|\[/)
  end
end
