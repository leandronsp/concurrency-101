require './live-coding/bg-jobs/sleeper_job'

class Main
  def initialize
    @queue = Array.new
    @mutex = Mutex.new
  end

  def enqueue!
    1000.times do |idx|
      @queue << SleeperJob.new(10, 0.005)
    end
  end

  def process!
    1000.times.map do
      Thread.new do
        @mutex.synchronize do
          job = @queue.shift

          puts "[Started] #{job}"

          job.perform
        end
      end
    end.each(&:join)
  end
end

initial_time = Time.now

main = Main.new

main.enqueue!
main.process!

puts "Done in #{Time.now - initial_time}"
