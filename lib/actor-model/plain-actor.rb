require './lib/simple-queue'

class Account
  def initialize(balance = 0)
    balance = balance
    @inbox   = SimpleQueue.new
    @outbox  = SimpleQueue.new

    Thread.new do
      loop do
        message = @inbox.pop

        case message
        in increment: value
          balance += value.to_i
        in get: :balance
          @outbox.push(balance)
        end
      end
    end
  end

  def increment(value)
    @inbox.push(increment: value)
  end

  def balance
    @inbox.push(get: :balance)
    @outbox.pop
  end
end

initial_time = Time.now
account = Account.new

2.times.map do
  Thread.new do
    500_000.times do
      account.increment(1)
    end
  end
end.each(&:join)

puts "Balance is: #{account.balance}"
puts "Done in #{Time.now - initial_time} seconds"
