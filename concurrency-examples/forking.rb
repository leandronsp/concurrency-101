require './lib/fib-sequence'

puts "Main process: #{Process.pid}"
initial_time = Time.now

fork do
  puts "Fork process: #{Process.pid}"
  FibSequence.call(80, 30)
end

FibSequence.call(80, 30)

Process.waitall
puts "Done in #{Time.now - initial_time} seconds"
