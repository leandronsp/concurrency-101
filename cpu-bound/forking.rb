require './cpu-bound/computation'

puts "Main ID: #{Process.pid}"

initial_time = Time.now

10.times do
  fork do
    puts "Fork ID: #{Process.pid}"
    computation
  end
end

Process.waitall

puts "Done in #{Time.now - initial_time} seconds"
