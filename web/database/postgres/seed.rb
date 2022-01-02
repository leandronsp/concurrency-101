require 'pg'
require 'json'
require 'faker'

initial_time = Time.now

conn = PG.connect(host: 'postgres', user: 'test',
                  password: 'test', dbname: 'test')

drop_table =
  """
  DROP INDEX IF EXISTS email_idx;
  DROP TABLE IF EXISTS users
  """

create_table =
  """
  CREATE TABLE users (
    id SERIAL,
    email VARCHAR(50) UNIQUE,
    name VARCHAR(80)
  )
  """

create_email_idx =
  """
  CREATE UNIQUE INDEX email_idx
  ON users (email)
  """

conn.exec(drop_table)
conn.exec(create_table)
conn.exec(create_email_idx)

total = 1_000_000
number_of_slices = 1_000

(1..total).each_slice(total / 2) do |half|
  fork do
    wid = Process.pid

    conn = PG.connect(host: 'postgres', user: 'test',
                      password: 'test', dbname: 'test')

    total_pages = half.size / number_of_slices
    puts "[#{wid}] Total pages: #{total_pages}"

    half.each_slice(number_of_slices) do |slice|
      rows = slice.map do |number|
        ["('wild#{number}@example.com','A wild #{number}')"]
      end

      conn.exec("INSERT INTO users (email, name) VALUES #{rows.join(',')}")
      total_pages -= 1
      puts "[#{wid}] Page: #{total_pages}"
    end

    conn.close
  end
end

Process.waitall

puts "Done in #{Time.now - initial_time} seconds"
