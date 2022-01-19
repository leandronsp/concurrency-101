require './live-coding/bg-jobs/sleeper_job'

class Main
  def initialize
    @queue = Queue.new
  end

  def enqueue(job_klass, args)
    @queue.push(job_klass.new(*args))
  end

  def start_workers!
    # 4 Workers
    4.times do
      Thread.new do
        wid = Thread.current.object_id
        puts "Worker ID: #{wid}"

        loop do
          job = @queue.pop
          next unless job

          puts "[Started] #{job}"

          job.perform
        end
      end
    end
  end
end

## --- ##

main = Main.new
main.start_workers!

loop do
  puts "Enfileirar jobs? (y/n) => "
  option = gets.chomp

  abort if option != 'y'

  50.times do |idx|
    main.enqueue(SleeperJob, [idx + 1, 0.005])
  end
end
