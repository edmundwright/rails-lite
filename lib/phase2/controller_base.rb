module Phase2
  class ControllerBase
    attr_reader :req, :res

    def initialize(req, res)
      @req, @res = req, res
    end

    def render_content(content, content_type)
      raise "Response already built!" if already_built_response?

      res.body = content
      res.content_type = content_type

      record_response_built
    end

    def redirect_to(url)
      raise "Response already built!" if already_built_response?

      res["location"] = url
      res.status = 302
      
      record_response_built
    end

    def already_built_response?
      @already_built_response
    end

    def record_response_built
      @already_built_response = true
    end
  end
end
