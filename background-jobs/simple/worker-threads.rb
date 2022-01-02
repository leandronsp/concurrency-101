require './lib/fib-sequence'
require './lib/sleeper'
require './lib/simple-queue'
require 'async'

queue = SimpleQueue.new

### Worker ###

2.times do
  Thread.new do
    wid = Thread.current.object_id
    puts "Created worker with ID: #{wid}. Waiting for jobs..."

    loop do
      job = queue.pop

      initial_time = Time.now
      action, args, times, concurrency =
        job.values_at(:action, :args, :times, :concurrency)

      puts "[#{wid}] Started job #{action} with #{args} for #{times} times"

      case concurrency
        in :fiber
        reactor = Async::Reactor.new
        Fiber.set_scheduler Async::Scheduler.new(reactor)

        times.times do
          Fiber.schedule do
            action.call(*args)
          end
        end

        reactor.run
        in :ractor
        times.times.map do
          Ractor.new(action, args) do |action, args|
            action.call(*args)
          end
        end.each(&:take)
      end

      puts "[#{wid}] Finished #{action} with args #{args} in #{Time.now - initial_time} seconds"
    end
  end
end

loop do
  puts "Enfileirar jobs? (y/n)"
  option = gets.chomp

  abort unless option == 'y'

  15.times do
    queue.push({ action: Sleeper, args: [0.005], times: 30_000, concurrency: :fiber })
    queue.push({ action: FibSequence, args: [30], times: 20, concurrency: :ractor })
  end
end
