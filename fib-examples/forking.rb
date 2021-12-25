require './lib/fib-sequence'

puts "Main process: #{Process.pid}"
initial_time = Time.now

5.times do
  fork do
    puts "Fork process: #{Process.pid}"

    30.times do
      FibSequence.fib(30)
    end
  end
end

Process.waitall
puts "Done in #{Time.now - initial_time} seconds"
