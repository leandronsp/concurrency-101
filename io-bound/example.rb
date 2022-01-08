initial_time = Time.now

@waiting = {}

2.times.map do
  Fiber.new do
    @waiting[Fiber.current] = []

    10.times do
      thread = Thread.new do
        sleep 0.5
      end

      @waiting[Fiber.current] << thread
    end

    Fiber.yield
  end.resume
end

while @waiting.any?
  @waiting.each do |fiber, threads|
    if threads.none?(&:alive?)
      @waiting.delete(fiber)
      fiber.resume
    end
  end
end

puts "Done in #{Time.now - initial_time} seconds"
