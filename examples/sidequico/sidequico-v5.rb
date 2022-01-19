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

class WorkerPool
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
  def self.start(processes_count: 2, workers_count: 4)
    new(processes_count, workers_count)
  end

  def initialize(processes_count, workers_count)
    @redis = Redis.new(host: 'redis')

    puts 'SideQuico has started'
    puts "Processes: #{processes_count}"
    puts "Workers: #{workers_count}"

    processes_count.times do
      fork do
        worker_pool = WorkerPool.new(size: workers_count)

        loop do
          data         = JSON.parse(@redis.blpop('myqueue')[1])
          action, args = data.values_at('action', 'args')
          job          = Object.const_get(action).new(*args)

          worker_pool.perform(job)
        end
      end
    end
  end
end

SideQuico.start(
  processes_count: 2,
  workers_count: 4
)

Process.waitall
