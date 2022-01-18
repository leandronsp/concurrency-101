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

@state = Cractor.new(0) do |instance, balance|
  loop do
    message = instance.receive

    case message
    in increment: value then balance += value.to_i
    in get: :balance    then instance.yield(balance)
    end
  end
end

100.times do
  @state.send({ increment: 1 })
end

balance = @state.send({ get: :balance }).take

puts "Balance is: #{balance}"
