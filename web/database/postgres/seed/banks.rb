require 'json'
require 'async'
require './lib/thread-pool'
require './lib/db-connection'

initial_time = Time.now

total = 500

(1..total).each_slice(total / 2) do |half|
  fork do
    wid = Process.pid

    conn = DBConnection.test

    filename = "/tmp/banks-#{half[0]}.csv"

    sql =
      """
      COPY (
        SELECT
          'bank' || num AS code,
          'The Bank ' || num AS name
        FROM generate_series(#{half[0]}, #{half[-1]}) AS num
      ) TO '#{filename}';
      COPY banks (code, name) FROM '#{filename}'
    """

    puts "[#{wid}]  #{sql}..."

    conn.async_exec(sql)
    conn.close

    puts "[#{wid}] Done"
  end
end

Process.waitall

puts "Done in #{Time.now - initial_time} seconds"
