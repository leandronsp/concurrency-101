require 'socket'
require 'async'

reactor = Async::Reactor.new
Fiber.set_scheduler Async::Scheduler.new(reactor)

PORT = ARGV[0].to_i

socket = TCPServer.new(PORT)
puts "Listening to the port #{PORT}..."

Fiber.schedule do
  loop do
    client = socket.accept

    Fiber.schedule do
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
  end
end

reactor.run
