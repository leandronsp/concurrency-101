require 'socket'

PORT = ARGV[0].to_i

socket = TCPServer.new(PORT)
puts "Listening to the port #{PORT}..."

loop do
  client = socket.accept

  request = ''

  while line = client.gets
    break if line == "\r\n"
    request += line
  end

  puts request

  sleep 0.005

  client.puts("HTTP/1.1 200\r\nContent-Type: text/html\r\n\r\nYo!")
  client.close
end
