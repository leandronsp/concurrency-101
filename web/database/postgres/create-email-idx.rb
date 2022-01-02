require 'json'
require 'faker'
require 'async'
require 'pg'

initial_time = Time.now

conn = PG.connect(host: 'postgres', user: 'test',
                  password: 'test', dbname: 'test')

conn.exec("CREATE INDEX email_idx ON users (email)")

puts "Done in #{Time.now - initial_time} seconds"
