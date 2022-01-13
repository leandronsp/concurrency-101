class Account
  def initialize(initial_balance = 0)
    @balance = initial_balance

    Thread.new do
      loop do
        @inbox.pop
      end
    end
  end

  def increment(value)
    @balance += value
  end

  def balance
    @balance
  end
end

account = Account.new

account.send(:increment, 42)

puts "Balance: #{account.send(:balance)}"
