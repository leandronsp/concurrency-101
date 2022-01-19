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

100.times do
  @inbox.push({ increment: 1 })
end

@inbox.push({ get: :balance })
balance = @outbox.pop

puts "Balance is: #{balance}"
