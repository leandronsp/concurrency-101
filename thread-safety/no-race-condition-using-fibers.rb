@balance = 0

def one; 1; end

100.times.map do
  Fiber.new do
    500_000.times do
      @balance += one
    end
  end
end.each(&:resume)

puts "Balance is: #{@balance}"
