class Flash
  def initialize(req)
    cookie = retrieve_cookie(req)

    if cookie
      from_cookie = JSON.parse(cookie.value)
      @not_now = from_cookie[:not_now]
      @now = from_cookie[:now]
    else
      @not_now, @now = {}, {}
    end
  end

  def now
  end

  private

  def retrieve_cookie(req)
    req.cookies.find do |cookie|
      cookie.name == "_rails_lite_app_flash"
    end
  end
end
