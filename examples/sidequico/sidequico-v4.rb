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

class ThreadPool
  def initialize(size: 4)
    @queue = SimpleQueue.new

    size.times do
      Thread.new do
        loop do
          job = @queue.pop

          puts "[Started] #{job}"
          job.perform
          puts "[Finished] #{job}"
        end
      end
    end
  end

  def perform(job)
    @queue.push(job)
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

        thread_pool = ThreadPool.new(size: 300)

        loop do
          data         = JSON.parse(@queue.blpop('myqueue')[1])
          action, args = data.values_at('action', 'args')
          job          = Object.const_get(action).new(*args)

          thread_pool.perform(job)
        end
      end
    end
  end
end

main = SideQuico.new
main.start!

Process.waitall
