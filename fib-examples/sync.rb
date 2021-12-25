require './lib/fib-sequence'

puts "Main process: #{Process.pid}"
initial_time = Time.now

150.times do
  FibSequence.fib(30)
end

puts "Done in #{Time.now - initial_time} seconds"
