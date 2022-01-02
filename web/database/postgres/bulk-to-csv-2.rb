require 'json'
require 'faker'
require 'async'
require 'pg'
require 'csv'

initial_time = Time.now

total = 10_000_000
number_of_slices = 20_000

(1..total).each_slice(total / 2) do |half|
  fork do
    wid = Process.pid
    reactor = Async::Reactor.new
    Fiber.set_scheduler Async::Scheduler.new(reactor)

    Fiber.schedule do
      total_pages = half.size / number_of_slices
      puts "[#{wid}] Total pages: #{total_pages}"

      conn = PG.connect(host: 'postgres', user: 'test',
                        password: 'test', dbname: 'test')
      conn.setnonblocking(true)

      conn.exec("SELECT 'wild' || num || '@example.com' AS email,
                'A wild ' || num AS name
                FROM generate_series(1, 1000000) AS num
    end

    reactor.run
  end
end

Process.waitall

puts "Done in #{Time.now - initial_time} seconds"
