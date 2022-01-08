initial_time = Time.now

150.times.map do
  Thread.new do
    10.times do
      sleep 0.5
    end
  end
end.each(&:join)

puts "Done in #{Time.now - initial_time} seconds"
