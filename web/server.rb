require 'socket'
require 'async'
require 'byebug'

socket = TCPServer.new(3000)
puts "Listening to the port 3000..."

reactor = Async::Reactor.new
Fiber.set_scheduler Async::Scheduler.new(reactor)

@counter = 0
@times = 5
@sleep_time = 0.5

def sync
  @times.times do
    sleep @sleep_time
  end
end

def threaded
  @times.times.map do
    Thread.new do
      sleep @sleep_time
    end
  end.each(&:join)
end

def fibers
  @times.times do
    Fiber.schedule do
      sleep @sleep_time
    end
  end
end

def response
  <<-HTTP
HTTP/2 200\r
Content-Type: text/html\r
Expires: Mon, 25 Jun 2023 21:31:12 GMT\r
Set-Cookie: counter=#{@counter}; path=/; HttpOnly\r
\r
<h1>Counter: #{@counter}</h1>
<a href="javascript:location.reload(true)">Reload with refresh</a>
<br/>
<a href="/">Reload without refresh</a>
HTTP
end

loop do
  client, _     = socket.accept
  first_line    =  client.gets

  if first_line
    verb, path, _ = first_line.split(' ')

    request = ''
    headers = {}
    body    = ''
    params  = {}
    cookies = {}

    while line = client.gets
      break if line == "\r\n"
      request += line

      if line.match(/.*?:.*?/)
        hname, hvalue = line.split(': ')
        headers[hname] = hvalue.chomp
      end
    end

    if content_length = headers['Content-Length']
      body = client.read(content_length.to_i)
      params = JSON.parse(body)
      request += "\n#{body}"
    end

    if cookie_value = headers['Cookie']
      key, value = cookie_value.split('=')
      cookies[key] = value
    end

    puts first_line
    puts request
    puts

    @counter = cookies.fetch('counter', 0).to_i + 1

    sync

    client.puts(response)
  end

  client.close
end

#reactor.run
