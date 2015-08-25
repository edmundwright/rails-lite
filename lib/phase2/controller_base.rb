module Phase2
  class ControllerBase
    attr_reader :req, :res

    def initialize(req, res)
      @req, @res = req, res
    end

    # Raise an error if the developer tries to double render.
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

    def already_built_response?
      @already_built_response
    end

    def record_response_built
      @already_built_response = true
    end
  end
end
