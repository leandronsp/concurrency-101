require './lib/fib-sequence'

puts "Main process: #{Process.pid}"
initial_time = Time.now
threads = []

5.times do
  threads << Thread.new do
    puts "Thread process: #{Process.pid}"

    30.times do
      FibSequence.fib(30)
    end
  end
end

threads.each(&:join)

puts "Done in #{Time.now - initial_time} seconds"
