require 'json'
require 'async'
require './lib/thread-pool'
require './lib/db-connection'

initial_time = Time.now
wid = Process.pid

total_accounts = 1_000_000
total_banks = 500

conn = DBConnection.test

filename = "/tmp/accounts.csv"

sql =
	"""
	COPY (
		select
			(random() * (#{total_accounts} - 1) + 1)::int as user_id,
			(random() * (#{total_banks} - 1) + 1)::int as bank_id
		from
			generate_series(1, #{total_accounts}) as series
	) TO '#{filename}';

	COPY accounts (user_id, bank_id) FROM '#{filename}';
	"""

conn.async_exec(sql)

conn.close

puts "Done in #{Time.now - initial_time} seconds"
