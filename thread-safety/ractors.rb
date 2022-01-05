initial_time = Time.now

balance =
  100.times.map do
    Ractor.new do
      number = 0

      500_000.times do
        number += 1
      end

      Ractor.yield(number)
    end
  end.map(&:take).sum

puts "Balance is: #{balance}"

puts "Done in #{Time.now - initial_time} seconds"
