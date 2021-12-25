require 'fiber'
require './lib/sleeper'

puts "Main process: #{Process.pid}"
initial_time = Time.now

1_000.times do
  fork do
    Sleeper.call(0.005)
  end
end

Process.waitall

puts "Done in #{Time.now - initial_time} seconds"
