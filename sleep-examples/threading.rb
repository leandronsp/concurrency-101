require './lib/sleeper'

puts "Main process: #{Process.pid}"
initial_time = Time.now
threads = []

5.times do
  threads << Thread.new do
    Sleeper.call(5, 0.5)
  end
end

threads.each(&:join)

puts "Done in #{Time.now - initial_time} seconds"
