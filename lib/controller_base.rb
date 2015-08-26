require 'active_support'
require 'active_support/core_ext'
require 'erb'
require 'active_support/inflector'
require_relative 'params'
require_relative 'router'
require_relative 'session'
require_relative 'flash'
require 'byebug'

class ControllerBase
  @@protected_from_forgery = false

  def self.protect_from_forgery
    @@protected_from_forgery = true
  end

  def self.protected_from_forgery?
    @@protected_from_forgery
  end

  attr_reader :req, :res, :params

  def initialize(req, res, route_params = {})
    @req, @res = req, res
    @params = Params.new(req, route_params)
  end

  def session
    @session ||= Session.new(req)
  end

  def flash
    @flash ||= Flash.new(req)
  end

  def form_authenticity_token
    @form_authenticity_token || create_authenticity_token
  end

  def create_authenticity_token
    token = SecureRandom.urlsafe_base64(16)
    cookie = WEBrick::Cookie.new("_rails_lite_app_auth", token)
    cookie.path = "/"
    res.cookies << cookie
    @form_authenticity_token = token
  end

  def retrieve_auth_token_from_cookie
    cookie = req.cookies.find do |cookie|
      cookie.name == "_rails_lite_app_auth"
    end

    cookie ? cookie.value : nil
  end

  def store_flash_and_session
    session.store_session(res)
    flash.store_flash(res)
  end

  def render_content(content, content_type)
    raise "Response already built!" if already_built_response?

    res.body = content
    res.content_type = content_type

    record_response_built
    store_flash_and_session
  end

  def redirect_to(url)
    raise "Response already built!" if already_built_response?

    res["location"] = url
    res.status = 302

    record_response_built
    store_flash_and_session
  end

  def already_built_response?
    @already_built_response
  end

  def record_response_built
    @already_built_response = true
  end

  def render(template_name)
    template_path = "views/#{self.class.to_s.underscore}/#{template_name}.html.erb"
    template = ERB.new(File.read(template_path))
    evaluated_template = template.result(binding)

    render_content(evaluated_template, "text/html")
  end

  def invoke_action(name)
    if self.class.protected_from_forgery? && req.request_method != "GET"
      auth_token_from_cookie = retrieve_auth_token_from_cookie

      raise "FORGERY!!!!!!!!" unless auth_token_from_cookie &&
        params[:authenticity_token] == auth_token_from_cookie
    end

    send(name)
    render name unless already_built_response?
  end
end
