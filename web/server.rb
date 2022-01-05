require 'socket'

socket = TCPServer.new(3000)
puts "Listening to the port 3000..."

loop do
  client, _ = socket.accept

  while line = client.gets
    puts line
    break if line == "\r\n"
  end

  client.puts("HTTP/1.1 200\r\nContent-Type: text/html\r\n\r\nRuby Yo!")
  client.close
end
