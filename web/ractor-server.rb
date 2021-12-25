require 'socket'
require 'async'

def do_some_io
  fibers = []

  20.times do
    fibers << Fiber.new do
      sleep 0.0005
    end
  end

  fibers.each(&:resume)
end

def do_external_request
  URI.open('http://sleeper:3004/')
end

pipe = Ractor.new do
  loop do
    Ractor.yield(Ractor.recv, move: true)
  end
end

CPU_COUNT = 2

workers = CPU_COUNT.times.map do
  Ractor.new(pipe) do |pipe|
    loop do
      client = pipe.take
      request = client.gets
      puts "Request: #{request}"

      #do_some_io
      do_external_request

      client.puts("HTTP/1.1 200\r\nContent-Type: text/html\r\n\r\nYo!")
      client.close
    end
  end
end

listener = Ractor.new(pipe) do |pipe|
  socket = TCPServer.new(3000)
  puts "Listening to the port 3000..."

  loop do
    client = socket.accept
    pipe.send(client, move: true)
  end
end

loop do
  Ractor.select(listener, *workers)
end
