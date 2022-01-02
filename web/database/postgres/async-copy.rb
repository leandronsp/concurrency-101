require 'json'
require 'faker'
require 'async'
require 'pg'

initial_time = Time.now

total = 10_000_000
number_of_slices = 50_000

(1..total).each_slice(total / 2) do |half|
  fork do
    wid = Process.pid

    conn = PG.connect(host: 'postgres', user: 'test',
                      password: 'test', dbname: 'test')

    conn.setnonblocking(true)

    total_pages = half.size / number_of_slices
    puts "[#{wid}] Total pages: #{total_pages}"

    conn.copy_data("COPY users (email, name) FROM STDIN DELIMITER ','") do
      half.each_slice(number_of_slices) do |slice|
        slice.each do |number|
          copy_data = "wild#{number}@example.com,A wild #{number}\n"
          conn.put_copy_data(copy_data)
        end

        total_pages -= 1
        puts "[#{wid}] Page: #{total_pages}"
      end
    end

    conn.close
  end
end

Process.waitall

puts "Done in #{Time.now - initial_time} seconds"
