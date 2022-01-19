ractor_queue = Ractor.new do
  loop do
    Ractor.yield(Ractor.receive)
  end
end

ractor_queue.send(1)
ractor_queue.send(2)
ractor_queue.send(3)

puts ractor_queue.take
puts ractor_queue.take
puts ractor_queue.take

class ActorQueue
  def initialize
    @inbox  = Queue.new
    @outbox = Queue.new

    Thread.new do
      loop do
        @outbox.push(@inbox.pop)
      end
    end
  end

  def send(element)
    @inbox.push(element)
  end

  def take
    @outbox.pop
  end
end

actor_queue = ActorQueue.new

actor_queue.send(1)
actor_queue.send(2)
actor_queue.send(3)

puts actor_queue.take
puts actor_queue.take
puts actor_queue.take
