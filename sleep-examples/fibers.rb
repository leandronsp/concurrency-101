require 'fiber'
require 'async'
require './lib/async-sleeper'

puts "Main process: #{Process.pid}"
initial_time = Time.now
fibers = []

Fiber.set_scheduler Async::Scheduler.new(Async::Reactor.new)

5.times do
  fibers << Fiber.new do
    AsyncSleeper.call(5, 0.5)
  end
end

fibers.each(&:resume)

puts "Done in #{Time.now - initial_time} seconds"
