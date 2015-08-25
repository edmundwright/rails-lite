require 'webrick'

server = WEBrick::HTTPServer.new(Port: 3000)

server.mount_proc("/") do |request, response|
  response.content_type = "text/type"
  response.body = "So you want to go to #{request.path}, eh? Tough luck!"
end

trap('INT') do
  server.shutdown
end

server.start
