require 'redis'
require 'json'
require './lib/fib-sequence'
require './lib/sleeper'

redis = Redis.new(host: 'redis')

### ENQUEUER ###
@options_map = {
  1 => FibSequence,
  2 => Sleeper,
  0 => 'Sair'
}

@concurrency_strategies_map = {
  1 => :forking,
  2 => :threading,
  3 => :fiber,
  4 => :ractor,
  0 => :no_concurrency
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

def menu_concurrency_strategy
  puts "###### Concorrência ######"
  puts "Qual estratégia de concorrência?"
  puts "0. Sem concorrência"
  puts "1. Forking"
  puts "2. Threading"
  puts "3. Fiber"
  puts "4. Ractor"
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

  menu_concurrency_strategy

  concurrency_strategy_option = gets.to_i
  concurrency_strategy = @concurrency_strategies_map[concurrency_strategy_option]

  payload = { action: action, args: action_args, times: times, concurrency_strategy: concurrency_strategy }.to_json
  redis.rpush('myqueue', payload)
end
