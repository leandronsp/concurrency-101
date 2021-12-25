@balance = 0

def one; 1; end

set_initial_balance = Thread.new do
  Thread.stop
  @balance = 42
end

decrement_balance = Thread.new do
  @balance -= one
end

decrement_balance.join

puts "Balance is: #{@balance}"
