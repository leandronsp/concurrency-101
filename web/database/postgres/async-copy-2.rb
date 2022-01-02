require 'json'
require 'faker'
require 'async'
require 'pg'
require './lib/thread-pool'

initial_time = Time.now

total = 10_000_000
number_of_slices = 10_000
(1..total).each_slice(total / 2) do |half|
  fork do
    wid = Process.pid

    total_pages = half.size / number_of_slices
    puts "[#{wid}] Total pages: #{total_pages}"

    conn = PG::Connection.async_connect(host: 'postgres', user: 'test',
                                        password: 'test', dbname: 'test')

    half.each_slice(number_of_slices) do |slice|
      filename = "/tmp/users-#{slice[0]}.csv"

      sql =
        """
      COPY (
        SELECT
          'wild' || num || '@example.com' AS email,
          'A wild ' || num AS name
        FROM generate_series(#{slice[0]}, #{slice[-1]}) AS num
      ) TO '#{filename}';
      COPY users (email, name) FROM '#{filename}'
      """

      conn.async_exec(sql)

      total_pages -= 1
      puts "[#{wid}] Page: #{total_pages}"
    end

    conn.close
  end
end

Process.waitall

puts "Done in #{Time.now - initial_time} seconds"
