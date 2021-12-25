require 'socket'
require 'net/http'

def do_some_io
  20.times do
    sleep 0.0005
  end
end

def do_external_request
  uri = URI('http://sleeper:3004/')
  Net::HTTP.get(uri)
end

socket = TCPServer.new(3000)
puts "Listening to the port 3000..."

loop do
  client = socket.accept
  request = client.gets

  puts "Request: #{request}"

  do_some_io
  do_external_request

  client.puts("HTTP/1.1 200\r\nContent-Type: text/html\r\n\r\nYo!")
  client.close
end
