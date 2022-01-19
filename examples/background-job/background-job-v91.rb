class SimpleQueue
  def initialize
    @queue   = Array.new
    @mutex   = Mutex.new
    @emitter = ConditionVariable.new
  end

  def push(element)
    @mutex.synchronize do
      @queue << element
      @emitter.signal
    end
  end

  def pop
    @mutex.synchronize do
      while @queue.empty?
        @emitter.wait(@mutex)
      end

      @queue.shift
    end
  end
end

class Main
  def initialize
    @queue = SimpleQueue.new
  end

  def enqueue(job_klass, args)
    @queue.push(job_klass.new(*args))
  end

  def start_workers!
    4.times.map do
      Thread.new do
        loop do
          job = @queue.pop
          puts "[Started] #{job}"

          job.perform
        end
      end
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
main.start_workers!

loop do
  puts "Enfileirar jobs? (y/n) => "
  option = gets.chomp

  abort unless option == 'y'

  50.times do |idx|
    main.enqueue(SleeperJob, [idx + 1, 0.005])
  end
end

puts "Done in #{Time.now - initial_time} seconds"
