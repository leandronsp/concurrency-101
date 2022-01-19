class Main
  def initialize
    @queue = Array.new
  end

  def enqueue!
    @queue << lambda do
      1_000.times { sleep(0.005) }
    end
  end

  def process!
    job = @queue.shift
    job.call
  end
end

initial_time = Time.now

main = Main.new

main.enqueue!
main.process!

puts "Done in #{Time.now - initial_time} seconds"
