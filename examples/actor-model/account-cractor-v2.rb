class Cractor
  def initialize(*args, &block)
    @inbox  = Queue.new
    @outbox = Queue.new

    Thread.new do
      result = yield(self, *args)

      self.yield(result)
    end

    self
  end

  def receive
    @inbox.pop
  end

  def send(element)
    @inbox.push(element)
    self
  end

  def yield(element)
    @outbox.push(element)
  end

  def take
    @outbox.pop
  end
end

class Account
  def initialize(balance = 0)
    @state = Cractor.new(balance) do |instance, balance|
      loop do
        message = instance.receive

        case message
        in increment: value then balance += value.to_i
        in get: :balance    then instance.yield(balance)
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

account = Account.new

100.times do
  account.increment(1)
end

puts "Balance is: #{account.balance}"
