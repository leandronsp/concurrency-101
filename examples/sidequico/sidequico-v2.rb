require 'redis'
require 'json'

class SleeperJob
  def initialize(*args)
    @args = args
    @times, @amount = args
  end

  def perform
    @times.times do
      sleep(@amount)
    end
  end

  def to_s
    "#{self.class.name} ID #{self.object_id} with args #{@args}"
  end
end

class SideQuico
  def initialize
    @queue = Redis.new(host: 'redis')
  end

  def start_workers!
    4.times.map do
      fork do
        wid = Process.pid
        puts "Created worker with ID: #{wid}. Waiting for jobs..."

        loop do
          data         = JSON.parse(@queue.blpop('myqueue')[1])
          action, args = data.values_at('action', 'args')
          job          = Object.const_get(action).new(*args)

          Thread.new do
            puts "[Started] #{job}"

            job.perform

            puts "[Finished] #{job}"
          end
        end
      end
    end
  end
end

main = SideQuico.new
main.start_workers!

Process.waitall
