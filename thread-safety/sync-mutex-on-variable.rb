@balance = 0
@mutex = Mutex.new

def one; 1; end

100.times.map do
  Thread.new do
    500_000.times do
      @mutex.synchronize do
        @balance += one
      end
    end
  end
end.each(&:join)

puts "Balance is: #{@balance}"
