require 'socket'
require 'async'

socket = TCPServer.new('0.0.0.0', 3000)
puts "Listening to the port 3000..."

reactor = Async::Reactor.new
Fiber.set_scheduler(Async::Scheduler.new(reactor))

loop do
  # Connection arrived
  client = socket.accept

  request = client.gets
  puts request

  10.times.map do
    Fiber.schedule do
      sleep 0.005
    end
  end

  client.puts("HTTP/1.1 200\nContent-Type: text/html\n\n<h1>OK</h1>")

  client.close
end

reactor.run
