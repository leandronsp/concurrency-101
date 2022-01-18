require 'redis'
require 'json'

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

class Main
  def initialize
    @queue = Redis.new(host: 'redis')
  end

  def enqueue(job_klass, args)
    @queue.rpush('myqueue', { action: job_klass, args: args }.to_json)
  end

  def start_workers!
    4.times.map do
      fork do
        loop do
          data         = JSON.parse(@queue.blpop('myqueue')[1])
          action, args = data.values_at('action', 'args')
          job          = Object.const_get(action).new(*args)

          puts "[Started] #{job}"
          job.perform
        end
      end
    end
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
    main.enqueue('SleeperJob', [idx + 1, 0.005])
  end
end

Process.waitall

puts "Done in #{Time.now - initial_time} seconds"
