require './cpu-bound/computation'

puts "Main ID: #{Process.pid}"

initial_time = Time.now

1000.times.map do
  Ractor.new do
    computation
  end
end.each(&:take)

puts "Done in #{Time.now - initial_time} seconds"
