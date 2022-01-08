initial_time = Time.now

@balance = 0

def one
  1.tap { sleep 0.001 }
end

50.times do
  200.times.map do
    Thread.new do
      File.read('./Makefile')
      @balance += 1
    end
  end.each(&:join)

  puts "Balance is: #{@balance}"
end

puts "Done in #{Time.now - initial_time} seconds"
