require 'json'
require 'faker'
require 'async'
require './lib/thread-pool'
require './lib/db-connection'

initial_time = Time.now

total = 10_000_000

(1..total).each_slice(total / 2) do |half|
  fork do
    wid = Process.pid

    conn = DBConnection.test

    filename = "/tmp/users-#{half[0]}.csv"

    sql =
      """
      COPY (
        SELECT
          'wild' || num || '@example.com' AS email,
          'A wild ' || num AS name
        FROM generate_series(#{half[0]}, #{half[-1]}) AS num
      ) TO '#{filename}';
      COPY users (email, name) FROM '#{filename}'
    """

    puts "[#{wid}]  #{sql}..."

    conn.async_exec(sql)
    conn.close

    puts "[#{wid}] Done"
  end
end

Process.waitall

puts "Done in #{Time.now - initial_time} seconds"
