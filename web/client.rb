require 'socket'

server = TCPSocket.new('nodejs', 4000)

request = "Hello Server\n"
server.write(request)

response = server.read

puts "Response: #{response}"

server.close
