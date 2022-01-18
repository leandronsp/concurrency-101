require 'socket'

PORT, CONCURRENCY = ARGV.values_at(0, 1).map(&:to_i)

@queue = Ractor.new do
  loop do
    Ractor.yield(Ractor.receive, move: true)
  end
end

workers = CONCURRENCY.times.map do
  Ractor.new(@queue) do |queue|
    loop do
      client = queue.take

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

listener = Ractor.new(@queue) do |queue|
  socket = TCPServer.new(PORT)
  puts "Listening to the port #{PORT}..."

  loop do
    client = socket.accept

    queue.send(client, move: true)
  end
end

loop do
  Ractor.select(listener, *workers)
end
