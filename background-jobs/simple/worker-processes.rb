require './lib/fib-sequence'
require './lib/sleeper'
require './lib/simple-queue'
require 'async'
require 'json'
require 'redis'

queue = Redis.new(host: 'redis')

### Worker ###

2.times do
  fork do
    wid = Process.pid
    puts "Created worker with ID: #{wid}. Waiting for jobs..."

    loop do
      job = JSON.parse(queue.blpop('myqueue')[1])

      initial_time = Time.now
      action, args, times, concurrency =
        job.values_at('action', 'args', 'times', 'concurrency')

      puts "[#{wid}] Started job #{action} with #{args} for #{times} times"

      case concurrency.to_s
      in 'fiber'
        reactor = Async::Reactor.new
        Fiber.set_scheduler Async::Scheduler.new(reactor)

        times.times do
          Fiber.schedule do
            Object.const_get(action).call(*args)
          end
        end

        reactor.run
      in 'ractor'
        times.times.map do
          Ractor.new(action, args) do |action, args|
            Object.const_get(action).call(*args)
          end
        end.each(&:take)
      end

      puts "[#{wid}] Finished #{action} with args #{args} in #{Time.now - initial_time} seconds"
    end
  end
end

### Enqueuer ###
loop do
  puts "Enfileirar jobs? (y/n)"
  option = gets.chomp

  abort unless option == 'y'

  15.times do
    queue.rpush('myqueue', { action: 'Sleeper', args: [0.005], times: 30_000, concurrency: :fiber }.to_json)
    queue.rpush('myqueue', { action: 'FibSequence', args: [30], times: 20, concurrency: :ractor }.to_json)
  end
end
