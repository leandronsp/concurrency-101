require 'redis'
require 'json'
require './lib/fib-sequence'
require './lib/sleeper'
require './background-jobs/concurrency-strategy'

### WORKERS ###
2.times do
  fork do
    wid = Process.pid
    puts "Started worker with ID: #{wid}. Waiting for jobs..."

    redis = Redis.new(host: 'redis')

    loop do
      payload = redis.brpop('myqueue')[1]
      job = JSON.parse(payload)

      action, args, times, concurrency_strategy = job
        .values_at('action', 'args', 'times', 'concurrency_strategy')

      initial_time = Time.now
      puts "[#{wid}] Starting job #{action} with args #{args} for #{times} times using concurrency strategy: #{concurrency_strategy}"

      strategy = ConcurrencyStrategy.new(action, args, times)

      strategy.send(concurrency_strategy.to_sym)

      puts "[#{wid}] Finished job in #{Time.now - initial_time} seconds"
    end
  end
end

Process.waitall
