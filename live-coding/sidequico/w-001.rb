require 'redis'
require 'json'
require './live-coding/bg-jobs/sleeper_job'

class SideQuico
  def initialize
    @redis = Redis.new(host: 'redis')
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

          job.perform # <--- assincrona? concorrente
        end
      end
    end
  end
end

main = SideQuico.new
main.start_workers!

Process.waitall
