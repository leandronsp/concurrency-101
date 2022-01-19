require 'socket'
require 'redis'
require 'json'

socket = TCPServer.new('0.0.0.0', 3000)
puts "Listening to the port 3000..."

queue = Redis.new(host: 'redis')

loop do
  client  = socket.accept
  first_line = client.gets
  puts first_line

  if first_line
    _, path, _ = first_line.split(' ')

    if matched = path.match(/^\/enqueue\/(\d+)$/)
      times = matched[1].to_i

      times.times do |idx|
        queue.rpush('myqueue', { action: 'SleeperJob', args: [idx + 1, 0.005] }.to_json)
      end
    end
  end

  client.puts("HTTP/1.1 200\nContent-Type: text/html\n\n<h1>OK</h1>")
  client.close
end
