require 'socket'
require 'async'
require './web/io-operation-threaded'

pipe = Ractor.new do
  loop do
    Ractor.yield(Ractor.receive, move: true)
  end
end

workers = 2.times.map do
  Ractor.new(pipe) do |pipe|
    loop do
      client = pipe.take
      request = client.gets
      puts "Request: #{request}"

      IOOperationThreaded.call

      client.puts("HTTP/1.1 200\r\nContent-Type: text/html\r\n\r\nYo!")
      client.close
    end
  end
end

listener = Ractor.new(pipe) do |pipe|
  socket = TCPServer.new(3000)
  puts "Listening to the port 3000..."

  loop do
    client, _ = socket.accept

    pipe.send(client, move: true)
  end
end

loop do
  Ractor.select(listener, *workers)
end
