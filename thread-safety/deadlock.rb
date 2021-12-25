@balance = 0
@mutex = Mutex.new

def one; 1; end

set_initial_balance = Thread.new do
  @mutex.synchronize do
    Thread.stop
    @balance = 42
  end
end

decrement_balance = Thread.new do
  @mutex.synchronize do
    @balance -= one
  end
end

decrement_balance.join

puts "Balance is: #{@balance}"
