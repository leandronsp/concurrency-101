require 'json'
require 'async'
require './lib/thread-pool'
require './lib/db-connection'

initial_time = Time.now

total_transfers = 10_000_000
limit_account_id = 1_000_000
limit_amount = 100

(1..total_transfers).each_slice(total_transfers / 2) do |half|
	fork do
		wid = Process.pid
		conn = DBConnection.test
		filename = "/tmp/transfers-#{half[0]}.csv"
		sql =
			"""
	COPY (
		select
			(random() * (#{limit_account_id} - 1) + 1)::int as source_id,
			(random() * (#{limit_account_id} - 1) + 1)::int as target_id,
			(random() * (#{limit_amount} - 1) + 1)::int as amount,
			NOW() as timestamp
		from
			generate_series(#{half[0]}, #{half[-1]}) as series
	) TO '#{filename}';

	COPY transfers (source_account_id, target_account_id, amount, timestamp) FROM '#{filename}';
		"""
		puts "[#{wid}]  #{sql}..."

		conn.async_exec(sql)

		conn.close
	end
end


Process.waitall

puts "Done in #{Time.now - initial_time} seconds"
