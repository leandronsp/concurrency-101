@balance = 0

100.times.map do
  Thread.new do
    500_000.times do
      @balance += 1
    end
  end
end.each(&:join)

puts "Balance is: #{@balance}"