class FibSequence
  def self.call(times, limit)
    instance = new

    times.times do
      instance.send(:fib, limit)
    end
  end

  private

  def fib(n)
    n < 2 ? n : fib(n - 1) + fib(n - 2)
  end
end

