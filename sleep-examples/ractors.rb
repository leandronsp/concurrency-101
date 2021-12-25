require './lib/sleeper'

puts "Main process: #{Process.pid}"
initial_time = Time.now
ractors = []

1_000.times do
  ractors << Ractor.new do
    Sleeper.call(0.005)
  end
end

ractors.each(&:take)

puts "Done in #{Time.now - initial_time} seconds"
