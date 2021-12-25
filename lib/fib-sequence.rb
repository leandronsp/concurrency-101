class FibSequence
  def self.fib(n)
    n < 2 ? n : fib(n - 1) + fib(n - 2)
  end

  def self.call(n)
    fib(n.to_i)
  end
end
