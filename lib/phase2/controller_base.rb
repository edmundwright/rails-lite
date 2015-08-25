class Phase2::ControllerBase
  attr_reader :request, :response

  def initialize(request, response)
    @request, @response = request, response
  end

  def render_content(content, content_type)
    response.content = content
    response.content_type = content_type
    record_response_built
  end

  def redirect_to(url)
    response.header.location = url
    response.status = 302
    record_response_built
  end

  private

  def record_response_built
    @already_built_response = true
  end
end
