require 'active_support'
require 'active_support/core_ext'
require 'erb'
require 'active_support/inflector'

class ControllerBase
  attr_reader :req, :res, :params

  def initialize(req, res)
    @req, @res = req, res
    @params = Params.new(req, route_params)
  end

  def session
    @session ||= Session.new(req)
  end

  def render_content(content, content_type)
    raise "Response already built!" if already_built_response?

    res.body = content
    res.content_type = content_type

    record_response_built
    session.store_session(res)
  end

  def redirect_to(url)
    raise "Response already built!" if already_built_response?

    res["location"] = url
    res.status = 302

    record_response_built
    session.store_session(res)
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
    send(name)
    render name unless already_built_response?
  end
end
