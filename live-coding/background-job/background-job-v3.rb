class Main
  def initialize
    @queue = Array.new
  end

  def enqueue!
    @queue << SleeperJob.new(500, 0.005)
    @queue << SleeperJob.new(300, 0.005)
    @queue << SleeperJob.new(100, 0.005)
  end

  def process!
    @queue.shift.perform
    @queue.shift.perform
    @queue.shift.perform
  end
end

class SleeperJob
  def initialize(times, amount)
    @times = times
    @amount = amount
  end

  def perform
    puts "Performing Job ID #{self.object_id}"

    @times.times do
      sleep(@amount)
    end
  end
end

initial_time = Time.now

main = Main.new

main.enqueue!
main.process!

puts "Done in #{Time.now - initial_time} seconds"
