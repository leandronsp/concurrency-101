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
    50.times.map do
      Thread.new do
        job = @queue.shift

        puts "[Started] #{job}"

        job.perform
      end
    end.each(&:join)
  end
end

initial_time = Time.now

main = Main.new

main.enqueue!
main.process!

puts "Done in #{Time.now - initial_time}"
