class MyQueue
  def initialize
    @list = Array.new
  end

  def enq(element)
    @list << element
  end

  def deq
    @list.shift
  end

  def length
    @list.length
  end
end
