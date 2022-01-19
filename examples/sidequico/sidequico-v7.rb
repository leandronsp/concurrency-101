require 'redis'
require 'json'

class SimpleQueue
  def initialize
    @queue = Ractor.new do
      loop do
        Ractor.yield(Ractor.receive)
      end
    end
  end

  def push(element)
    @queue.send(element)
  end

  def pop
    @queue.take
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

class Worker
  def initialize(inbox)
    @inbox = inbox

    Ractor.new(inbox) do |inbox|
      loop do
        job = inbox.pop

        puts "[Started] #{job}"
        job.perform
        puts "[Finished] #{job}"
      end
    end
  end
end

class WorkerPool
  def initialize(size: 4)
    @inbox = SimpleQueue.new

    Ractor.new(size, @inbox) do |size, inbox|
      size.times { Worker.new(inbox) }
    end
  end

  def perform(job)
    @inbox.push(job)
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
        worker_pool  = WorkerPool.new(size: workers_count)

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
  processes_count: 4,
  workers_count: 50
)

Process.waitall
