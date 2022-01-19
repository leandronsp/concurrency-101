class Main
  def initialize
    @queue = Array.new
  end

  def enqueue!
    @queue << lambda do
      100.times do
        sleep 0.005
      end
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

puts "Done in #{Time.now - initial_time}"
