require './cpu-bound/computation'

puts "Main ID: #{Process.pid}"

initial_time = Time.now

1000.times.map do
  Thread.new do
    computation
  end
end.each(&:join)

puts "Done in #{Time.now - initial_time} seconds"
