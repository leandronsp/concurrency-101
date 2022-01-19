require './live-coding/bg-jobs/sleeper_job'

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
    while @queue.length > 0
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
