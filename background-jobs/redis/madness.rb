require 'redis'
require 'json'
require './lib/fib-sequence'
require './lib/sleeper'

redis = Redis.new(host: 'redis')

cpu_bound = { action: FibSequence, args: [30], times: 10, concurrency_strategy: :ractor }.to_json
io_bound = { action: Sleeper, args: [0.005], times: 30_000, concurrency_strategy: :fiber }.to_json

15.times do
  redis.rpush('myqueue', io_bound)
  redis.rpush('myqueue', cpu_bound)
end
