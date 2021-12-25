require 'fiber'
require 'async'
require './lib/sleeper'

initial_time = Time.now

reactor = Async::Reactor.new
Fiber.set_scheduler Async::Scheduler.new(reactor)

1_000.times do
  Fiber.schedule do
    Sleeper.call(0.005)
  end
end

reactor.run

puts "Done in #{Time.now - initial_time} seconds"
