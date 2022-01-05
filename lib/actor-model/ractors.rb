class Account
  def initialize(balance = 0)
    @state = Ractor.new(balance) do |balance|
      loop do
        message = Ractor.receive

        case message
        in increment: value
          balance += value.to_i
        in get: :balance
          Ractor.yield(balance)
        end
      end
    end
  end

  def increment(value)
    @state.send({ increment: value })
  end

  def balance
    @state.send({ get: :balance }).take
  end
end

initial_time = Time.now
account = Account.new

2.times.map do
  Ractor.new(account) do |account|
    500_000.times do
      account.increment(1)
    end
  end
end.each(&:take)

puts "Balance is: #{account.balance}"
puts "Done in #{Time.now - initial_time} seconds"
