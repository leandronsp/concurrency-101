class SynchronizedQueue
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
  alias_method :<<, :push
  alias_method :enq, :push

  def pop
    @mutex.synchronize do
      while @queue.empty?
        @received.wait(@mutex)
      end

      @queue.shift
    end
  end
  alias_method :deq, :pop
end
