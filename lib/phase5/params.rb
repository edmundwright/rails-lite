require 'uri'
require 'byebug'

module Phase5
  class Params
    attr_reader :params

    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
      @params = route_params.merge(parse_www_encoded_form(req.query_string))
    end

    def [](key)
      params[key.to_sym] || params[key.to_s]
    end

    # this will be useful if we want to `puts params` in the server log
    def to_s
      params.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private

    def parse_www_encoded_form(www_encoded_form)
      result = {}

      URI::decode_www_form(www_encoded_form.to_s).each do |key, value|
        result[key] = value
      end

      result
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
    end
  end
end
