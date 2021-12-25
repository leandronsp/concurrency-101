require './lib/sleeper'

puts "Main process: #{Process.pid}"
initial_time = Time.now
threads = []

1_000.times do
  threads << Thread.new do
    Sleeper.call(0.005)
  end
end

threads.each(&:join)

puts "Done in #{Time.now - initial_time} seconds"
