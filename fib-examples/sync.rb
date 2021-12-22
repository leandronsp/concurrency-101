require './lib/fib-sequence'

puts "Main process: #{Process.pid}"
initial_time = Time.now

5.times do
  FibSequence.call(30, 30)
end

puts "Done in #{Time.now - initial_time} seconds"
