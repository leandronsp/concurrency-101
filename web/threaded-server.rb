require 'socket'

PORT, CONCURRENCY = ARGV.values_at(0, 1).map(&:to_i)
@queue = Queue.new

socket = TCPServer.new(PORT)
puts "Listening to the port #{PORT}..."

CONCURRENCY.times do
  Thread.new do
    loop do
      client = @queue.pop

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

loop do
  client = socket.accept

  @queue.push(client)
end
