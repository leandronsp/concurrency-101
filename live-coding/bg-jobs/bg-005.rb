require './live-coding/bg-jobs/sleeper_job'

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
    while @queue.any?
      job = @queue.shift

      puts "[Started] #{job}"

      job.perform
    end
  end
end

initial_time = Time.now

main = Main.new

main.enqueue!
main.process!

puts "Done in #{Time.now - initial_time}"
