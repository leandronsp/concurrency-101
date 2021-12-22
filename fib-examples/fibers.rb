require './lib/fib-sequence'

puts "Main process: #{Process.pid}"
initial_time = Time.now
fibers = []

5.times do
  fibers << Fiber.new do
    puts "Fiber process: #{Process.pid}"
    FibSequence.call(30, 30)
  end
end

fibers.each(&:resume)

puts "Done in #{Time.now - initial_time} seconds"
