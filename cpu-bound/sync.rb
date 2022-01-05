require './cpu-bound/computation'

puts "ID: #{Process.pid}"

initial_time = Time.now

1000.times do
  computation
end

puts "Done in #{Time.now - initial_time} seconds"
