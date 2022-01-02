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

      CSV.open('emails-to-insert.csv', 'wb', col_sep: ',') do |csv|
        half.each_slice(number_of_slices) do |slice|
          Fiber.schedule do
            slice.each do |number|
              row = ["wild#{number}@example.com", "A wild #{number}"]
              csv << row
            end
          end

          total_pages -= 1
          puts "[#{wid}] Page: #{total_pages}"
        end
      end
    end

    reactor.run
  end
end

Process.waitall

puts "Done in #{Time.now - initial_time} seconds"
