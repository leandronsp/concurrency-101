require './lib/fib-sequence'

puts "Main process: #{Process.pid}"
initial_time = Time.now

5.times do
  fork do
    puts "Fork process: #{Process.pid}"
    FibSequence.call(30, 30)
  end
end

Process.waitall
puts "Done in #{Time.now - initial_time} seconds"
