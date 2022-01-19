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
