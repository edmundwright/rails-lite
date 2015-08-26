require 'json'
require 'webrick'

class Session
  attr_reader :session

  def initialize(req)
    existing_cookie = req.cookies.find do |cookie|
      cookie.name == "_rails_lite_app"
    end

    @session = existing_cookie.nil? ? {} : JSON.parse(existing_cookie.value)
  end

  def [](key)
    session[key.to_sym] || session[key.to_s]
  end

  def []=(key, val)
    session[key.to_sym] = val
  end

  def store_session(res)
    cookie = WEBrick::Cookie.new("_rails_lite_app", session.to_json)
    cookie.path = "/"
    res.cookies << cookie
  end
end
