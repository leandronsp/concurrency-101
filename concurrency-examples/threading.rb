require './lib/fib-sequence'

puts "Main process: #{Process.pid}"
initial_time = Time.now

thread = Thread.new do
  puts "Thread process: #{Process.pid}"
  FibSequence.call(100, 30)
end

FibSequence.call(100, 30)

thread.join

puts "Done in #{Time.now - initial_time} seconds"
