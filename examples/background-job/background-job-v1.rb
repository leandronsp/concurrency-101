initial_time = Time.now

queue = Array.new

queue << lambda { 100.times { sleep(0.005) }}

job = queue.shift

job.call

puts "Done in #{Time.now - initial_time} seconds"
