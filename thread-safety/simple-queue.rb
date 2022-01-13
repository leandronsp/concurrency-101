class SimpleQueue
  def initialize
    @queue = Array.new
    @mutex = Mutex.new
  end

  def pop
    @mutex.synchronize do
      @queue.shift
    end
  end

  def push(element)
    @mutex.synchronize do
      @queue << element
    end
  end
end

queue = SimpleQueue.new

10.times.map do |idx|
  Thread.new do
    queue.push(idx)
  end
end.each(&:join)

10.times do
  puts queue.pop
end

