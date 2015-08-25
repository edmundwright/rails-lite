require_relative '../phase2/controller_base'
require 'active_support'
require 'active_support/core_ext'
require 'erb'
require 'active_support/inflector'

module Phase3
  class ControllerBase < Phase2::ControllerBase

    def render(template_name)
      template_path = "views/#{self.class.to_s.underscore}/#{template_name}.html.erb"
      template = ERB.new(File.read(template_path))
      evaluated_template = template.result(binding)
      
      render_content(evaluated_template, "text/html")
    end
  end
end
