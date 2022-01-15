require 'socket'
require './live-coding/http_request_action'
require './live-coding/sleep_action'
require './live-coding/csv_read_action'

socket = TCPServer.new('0.0.0.0', 3000)
puts "Listening to the port 3000..."

action_klass = CSVReadAction

loop do
  client  = socket.accept
  first_line = client.gets
  puts first_line

  if first_line
    action = action_klass.new

    # GET /asdf HTTP/1.1
    _, path, _ = first_line.split(' ')

    case path
    in '/fibers'
      action.process_fibers
    in '/threads'
      action.process_threads
    in '/sync'
      action.process_sync
    in '/typhoeus'
      action.process_typhoeus
    in '/ractors'
      action.process_ractors
    in '/'
      action.process
    end

    client.puts("HTTP/1.1 200\nContent-Type: text/html\n\n<h1>#{action.response}</h1>")
  end

  client.close
end
