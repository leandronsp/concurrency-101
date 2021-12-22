require 'fiber'
require './lib/sleeper'

puts "Main process: #{Process.pid}"
initial_time = Time.now

5.times do
  fork do
    Sleeper.call(5, 0.5)
  end
end

Process.waitall

puts "Done in #{Time.now - initial_time} seconds"
