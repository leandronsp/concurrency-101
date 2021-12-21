class Sleeper
  def self.call(times, limit)
    instance = new

    times.times do
      instance.send(:do_sleep, limit)
    end
  end

  private

  def do_sleep(n)
    sleep n
  end
end

