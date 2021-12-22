require './lib/sleeper'

puts "Main process: #{Process.pid}"
initial_time = Time.now

5.times do
  Sleeper.call(5, 0.5)
end

puts "Done in #{Time.now - initial_time} seconds"
