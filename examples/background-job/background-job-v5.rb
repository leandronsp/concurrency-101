class Main
  def initialize
    @queue = Array.new
  end

  def enqueue!
    50.times do |idx|
      @queue << SleeperJob.new(idx + 1, 0.005)
    end
  end

  def process!
    50.times.map do
      job = @queue.shift

      puts "[Started] #{job}"

      job.perform
    end
  end
end

class SleeperJob
  def initialize(*args)
    @args = args
    @times, @amount = args
  end

  def perform
    @times.times do
      sleep(@amount)
    end
  end

  def to_s
    "#{self.class.name} ID #{self.object_id} with args #{@args}"
  end
end

initial_time = Time.now

main = Main.new

main.enqueue!
main.process!

puts "Done in #{Time.now - initial_time} seconds"
