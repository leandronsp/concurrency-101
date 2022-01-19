class Account
  def initialize
    @inbox  = Queue.new
    @outbox = Queue.new

    Thread.new do
      balance = 0

      loop do
        message = @inbox.pop

        case message
        in increment: value then balance += value.to_i
        in get: :balance    then @outbox.push(balance)
        end
      end
    end
  end

  def increment(value)
    @inbox.push({ increment: value })
  end

  def balance
    @inbox.push({ get: :balance })
    @outbox.pop
  end
end

account = Account.new

100.times do
  account.increment(1)
end

puts "Balance is: #{account.balance}"
