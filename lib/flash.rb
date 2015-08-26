class Flash
  attr_reader :now

  def initialize(req)
    @now = retrieve_and_parse_cookie(req)
    @next_time = {}
  end

  def [](key)
    now[key.to_sym] || now[key.to_s]
  end

  def []=(key, value)
    next_time[key.to_sym] = value
    now[key.to_sym] = value
  end

  def store_flash(res)
    cookie = WEBrick::Cookie.new("_rails_lite_app_flash", next_time.to_json)
    cookie.path = "/"
    res.cookies << cookie
  end

  private

  attr_reader :next_time

  def retrieve_and_parse_cookie(req)
    cookie = req.cookies.find do |cookie|
      cookie.name == "_rails_lite_app_flash"
    end

    cookie ? JSON.parse(cookie.value) : {}
  end
end
