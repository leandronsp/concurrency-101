class AsyncSleeper
  def self.call(times, limit)
    instance = new

    times.times do
      Fiber.new { instance.send(:do_sleep, limit) }.resume
    end
  end

  private

  def do_sleep(n)
    sleep n
  end
end

