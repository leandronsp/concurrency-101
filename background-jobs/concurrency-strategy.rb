require 'async'

class ConcurrencyStrategy
  def initialize(action, args, times)
    @action = action
    @args = args
    @times = times
  end

  def call
    Object.const_get(@action).call(*@args)
  end

  def no_concurrency
    @times.times { call }
  end

  def forking
    @times.times do
      fork { call }
    end

    Process.waitall
  end

  def threading
    Array.new(@times).map do
      Thread.new { call }
    end.each(&:join)
  end

  def fiber
    reactor = Async::Reactor.new
    Fiber.set_scheduler Async::Scheduler.new(reactor)

    @times.times do
      Fiber.schedule { call }
    end

    reactor.run
  end

  def ractor
    Array.new(@times).map do
      Ractor.new(@action, @args) do |action, args|
        Object.const_get(action).call(*args)
      end
    end.each(&:take)
  end
end
