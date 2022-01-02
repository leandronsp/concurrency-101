require './lib/fib-sequence'
require './lib/sleeper'
require './lib/synchronized-queue'

@queue = SynchronizedQueue.new

### WORKERS ###

2.times do
  Thread.new do
    wid = Thread.current.object_id

    puts "Started worker with ID: #{wid}. Waiting for jobs..."

    loop do
      job = @queue.pop

      action, args, times = job.values_at(:action, :args, :times)

      initial_time = Time.now
      puts "[#{wid}] Starting job #{action} with args #{args} for #{times} times"

      times.times do
        action.call(*args)
      end

      puts "[#{wid}] Finished job in #{Time.now - initial_time} seconds"
    end
  end
end

### ENQUEUER ###
@options_map = {
  1 => FibSequence,
  2 => Sleeper,
  0 => 'Sair'
}

def menu
  puts "###### Menu ######"
  puts "Qual ação deseja enfileirar?"

  @options_map.each do |(key, value)|
    puts "#{key}. #{value}"
  end
end

def menu_arguments
  puts "###### Argumentos ######"
  puts "Quais argumentos? e.g 30,42,50"
end

def menu_times
  puts "###### Repetição ######"
  puts "Por quantas vezes a ação deve ser executada?"
end

loop do
  menu

  option = gets.to_i

  action = @options_map[option]

  puts "Unkown option" if action.nil?
  abort if action == 'Sair'

  menu_arguments

  action_args = gets.split(',').map(&:to_f)

  menu_times

  times = gets.to_i

  @queue << { action: action, args: action_args, times: times }
end
