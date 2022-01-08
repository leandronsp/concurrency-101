require 'open3'

initial_time = Time.now

@waiting = {}

2.times.map do
  Fiber.new do
    10.times do
      _, _, _, pid = Open3.popen3("sleep 0.5")

      @waiting[Fiber.current] ||= []
      @waiting[Fiber.current] << pid
    end

    Fiber.yield
  end.resume
end

while @waiting.any?
  @waiting.each do |fiber, pids|
    if pids.map(&:status).all?(false)
      @waiting.delete(fiber)
      fiber.resume
    end
  end
end

puts "Done in #{Time.now - initial_time} seconds"
