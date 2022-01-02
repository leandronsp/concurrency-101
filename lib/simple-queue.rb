class SimpleQueue
  def initialize
    @queue = Array.new
    @mutex = Mutex.new
    @received = ConditionVariable.new
  end

  def push(element)
    @mutex.synchronize do
      @queue << element
      @received.signal
    end
  end

  def pop
    @mutex.synchronize do
      while @queue.empty?
        @received.wait(@mutex)
      end

      @queue.shift
    end
  end
end
