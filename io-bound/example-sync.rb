require 'open3'

initial_time = Time.now

2.times.map do
  10.times do
    sleep 0.5
  end
end

puts "Done in #{Time.now - initial_time} seconds"
