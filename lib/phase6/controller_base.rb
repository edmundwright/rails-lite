require_relative '../phase5/controller_base'

module Phase6
  class ControllerBase < Phase5::ControllerBase
    def invoke_action(name)
      send(name)
      render name unless already_built_response?
    end
  end
end
