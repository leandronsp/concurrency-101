require './lib/sleeper'

puts "Main process: #{Process.pid}"
initial_time = Time.now

1_000.times do
  Sleeper.call(0.005)
end

puts "Done in #{Time.now - initial_time} seconds"
