require 'json'
require 'webrick'
require 'byebug'

module Phase4
  class Session
    attr_reader :session

    def initialize(req)
      cookies = req.cookies.select { |cookie| cookie.name == "_rails_lite_app"}

      @session = cookies.empty? ? {} : JSON.parse(cookies.first.value)
    end

    def [](key)
      session[key]
    end

    def []=(key, val)
      @session[key] = val
    end

    def store_session(res)
      cookie = WEBrick::Cookie.new("_rails_lite_app", session.to_json)
      res.cookies << cookie
    end
  end
end
