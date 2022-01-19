require 'redis'
require 'json'
require './live-coding/bg-jobs/sleeper_job'

class Main
  def initialize
    @redis = Redis.new(host: 'redis')
  end

  def enqueue(job_klass, args)
    @redis.rpush('myqueue', { action: job_klass.to_s, args: args }.to_json)
  end

  def start_workers!
    4.times do
      fork do
        wid = Process.pid
        puts "Worker ID: #{wid}"

        loop do
          _queue_name, raw_value = @redis.blpop('myqueue')

          data = JSON.parse(raw_value)
          action, args = data.values_at('action', 'args')
          job = Object.const_get(action).new(*args)

          puts "[Started] #{job}"

          job.perform
        end
      end
    end
  end
end

## --- ##

main = Main.new
main.start_workers!

loop do
  puts "Enfileirar jobs? (y/n) => "
  option = gets.chomp

  abort if option != 'y'

  50.times do |idx|
    main.enqueue(SleeperJob, [idx + 1, 0.005])
  end
end

Process.killall
