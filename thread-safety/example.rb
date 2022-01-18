class ThreadPool
  attr_reader :queue

  def initialize(size)
    @size = size
    @jobs = Queue.new
    @pool = Array.new(size) do
      Thread.new do
        catch(:exit) do
          loop do
            job = @jobs.pop
            job.call
          end
        end
      end
    end
  end

  def perform(&block)
    @jobs << block
  end

  def shutdown
    @size.times do
      perform { throw :exit }
    end

    @pool.map(&:join)
  end
end

class SimpleQueue
  def initialize
    @queue = Array.new
    @mutex = Mutex.new
  end

  def push(element)
    @queue << element
  end

  def pop
    @queue.shift
  end

  def length
    @queue.length
  end
end

queue = SimpleQueue.new

50.times do |idx|
  queue.push(idx + 1)
end

mutex = Mutex.new

50.times.map do
  Thread.new do
    puts queue.pop
  end
end.each(&:join)
