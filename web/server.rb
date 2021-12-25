require 'socket'

socket = TCPServer.new(3000)
puts "Listening to the port 3000..."

loop do
  client = socket.accept
  request = client.gets

  client.puts("HTTP/1.1 200\r\nContent-Type: text/html\r\n\r\nYo!")
  client.close
end
