@queue    = Array.new
@mutex    = Mutex.new
@received = ConditionVariable.new

Thread.new do
  puts "[Worker] Waiting job in the queue..."

  loop do
    @mutex.synchronize do
      while @queue.empty?
        @received.wait(@mutex)
      end

      job = @queue.shift
      puts "[Worker] Received Job #{job}"
    end
  end
end

loop do
  sleep 0.05

  puts "Enqueue jobs? (y/n)"
  option = gets.chomp
  abort unless option == 'y'

  (1..10).each do |idx|
    @mutex.synchronize do
      @queue << "Job #{idx}"
      @received.signal
    end
  end
end
