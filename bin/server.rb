require_relative '../lib/active-record-lite/sql_object'
require_relative '../lib/controller_base'
Dir["../app/models/*.rb"].each {|file| require file }
require_relative '../app/controllers/application_controller.rb'
Dir["../app/controllers/*.rb"].each {|file| require file }

$router = Router.new

require_relative '../config/routes.rb'

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  route = $router.run(req, res)
end

trap('INT') { server.shutdown }
server.start
