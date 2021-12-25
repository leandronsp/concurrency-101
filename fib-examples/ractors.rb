require './lib/fib-sequence'

puts "Main process: #{Process.pid}"
initial_time = Time.now
ractors = []

5.times do
  ractors << Ractor.new do
    puts "Ractor process: #{Process.pid}"

    30.times do
      FibSequence.fib(30)
    end
  end
end

ractors.each(&:take)

puts "Done in #{Time.now - initial_time} seconds"
