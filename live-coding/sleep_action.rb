require 'async'

class SleepAction
  TIMES = 10.freeze

  def process_threads
    TIMES.times.map do
      Thread.new do
        sleep 0.005
      end
    end.each(&:join)
  end

  def process_sync
    TIMES.times do
      sleep 0.005
    end
  end

  def process_fibers
    reactor = Async::Reactor.new
    Fiber.set_scheduler(Async::Scheduler.new(reactor))

    TIMES.times.map do
      Fiber.schedule do
        sleep 0.005
      end
    end

    reactor.run

    #Async do
    #  TIMES.times.map do
    #    Async do |task|
    #      task.sleep 0.005
    #    end
    #  end
    #end
  end
end
