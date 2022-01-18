@state = Ractor.new(0) do |balance|
  loop do
    message = Ractor.receive

    case message
      in increment: value then balance += value.to_i
      in get: :balance    then Ractor.yield(balance)
    end
  end
end

100.times do
  @state.send({ increment: 1 })
end

balance = @state.send({ get: :balance }).take

puts "Balance is: #{balance}"
