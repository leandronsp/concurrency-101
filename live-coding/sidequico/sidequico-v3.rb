require 'redis'
require 'json'

class SimpleQueue
  def initialize
    @queue   = Array.new
    @mutex   = Mutex.new
    @emitter = ConditionVariable.new
  end

  def push(element)
    @mutex.synchronize do
      @queue << element
      @emitter.signal
    end
  end

  def pop
    @mutex.synchronize do
      while @queue.empty?
        @emitter.wait(@mutex)
      end

      @queue.shift
    end
  end
end

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

  def start!
    4.times.map do
      fork do
        wid = Process.pid
        puts "Created Fetcher with ID: #{wid}"

        worker_queue = SimpleQueue.new

        # Worker Pool
        4.times do
          Thread.new do
            wid = Thread.current.object_id
            puts "Created Worker with ID: #{wid}"

            loop do
              job = worker_queue.pop

              puts "[Started] #{job}"
              job.perform
              puts "[Finished] #{job}"
            end
          end
        end

        loop do
          data         = JSON.parse(@queue.blpop('myqueue')[1])
          action, args = data.values_at('action', 'args')
          job          = Object.const_get(action).new(*args)

          worker_queue.push(job)
        end
      end
    end
  end
end

main = SideQuico.new
main.start!

Process.waitall
