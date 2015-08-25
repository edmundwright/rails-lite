require 'webrick'

server = WEBrick::HTTPServer.new(Port: 3000)

trap('INT') do
  server.shutdown
end

server.start
