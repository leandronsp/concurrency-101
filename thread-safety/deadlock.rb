@balance = 0
@mutex = Mutex.new

bad_guy = Thread.new do
  @mutex.lock
  @balance += 1
  Thread.stop
  @mutex.unlock
end

good_guy = Thread.new do
  @mutex.lock
  @balance += 1
  @mutex.unlock
end

good_guy.join
bad_guy.join

puts "Balance is: #{@balance}"
