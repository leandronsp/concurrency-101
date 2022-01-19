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
    @queue.shift.perform
    @queue.shift.perform
    @queue.shift.perform
  end
end

initial_time = Time.now

main = Main.new

main.enqueue!
main.process!

puts "Done in #{Time.now - initial_time}"
