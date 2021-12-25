require 'socket'
require 'async'
require './web/io-operation-fiber'

reactor = Async::Reactor.new
Fiber.set_scheduler Async::Scheduler.new(reactor)

socket = TCPServer.new(3000)
puts "Listening to the port 3000..."

Fiber.schedule do
  loop do
    client = socket.accept
    request = client.gets

    puts "Request: #{request}"

    Fiber.schedule do
      IOOperationFiber.call

      client.puts("HTTP/1.1 200\r\nContent-Type: text/html\r\n\r\nYo!")
      client.close
    end
  end
end

reactor.run
