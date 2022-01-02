require 'pg'
require 'json'
require 'faker'
require 'async'
require 'async/postgres'

reactor = Async::Reactor.new
Fiber.set_scheduler Async::Scheduler.new(reactor)

initial_time = Time.now

Fiber.schedule do
  #conn = PG.connect(host: 'postgres', user: 'test',
  #                                       password: 'test', dbname: 'test')
  conn = Async::Postgres::Connection.new("host=postgres dbname=test user=test password=test")

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

  conn.async_exec(drop_table)
  conn.async_exec(create_table)
  conn.async_exec(create_email_idx)

  total = 10_000_000
  number_of_slices = 5_000

  total_pages = total / number_of_slices
  puts "Total pages: #{total_pages}"

  (1..total).each_slice(number_of_slices) do |slice|
    conn.copy_data("COPY users (email, name) FROM STDIN DELIMITER ','") do
      slice.each do |number|
        copy_data = "wild#{number}@example.com,A wild #{number}\n"
        conn.async_put_copy_data(copy_data)
      end
    end

    total_pages -= 1
    puts "Page: #{total_pages}"
  end
end

reactor.run

puts "Done in #{Time.now - initial_time} seconds"
