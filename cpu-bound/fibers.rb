require './cpu-bound/computation'

puts "Main ID: #{Process.pid}"

initial_time = Time.now

1000.times.map do
  Fiber.new do
    computation
  end
end.each(&:resume)

puts "Done in #{Time.now - initial_time} seconds"
