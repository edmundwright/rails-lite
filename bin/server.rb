#!/usr/bin/env ruby

require 'byebug'

require_relative '../lib/active-record-lite/sql_object'
require_relative '../lib/controller_base'
Dir["app/models/*.rb"].each {|file| require_relative "../#{file}" }
require_relative '../app/controllers/application_controller.rb'
Dir["app/controllers/*.rb"].each {|file| require_relative "../#{file}" }

$router = Router.new

require_relative '../config/routes.rb'

p 'Webrick server starting...'
server = WEBrick::HTTPServer.new(Port: ENV["PORT"] || 3000)
server.mount_proc('/') do |req, res|
  route = $router.run(req, res)
end

trap('INT') { server.shutdown }
server.start
