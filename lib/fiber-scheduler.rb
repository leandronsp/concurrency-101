require 'fiber'

class FiberScheduler
  def initialize
    # our internal Hash to track which Fiber is sleeping and for how long
    @waiting = {}
  end

  def run
    # we will loop until there is no more event
    # Our event loop for now will only check for sleeping fibers
    while @waiting.any?
      @waiting.keys.each do |fiber|
        # fiber needs to wake up
        if current_time > @waiting[fiber]
          @waiting.delete(fiber)
          fiber.resume
        end
      end
    end
  end

  def kernel_sleep(duration = nil)
    # this function(and other hooks) will run in context of the fiber calling sleep
    # hence Fiber.current will be our target fiber that need to be halted
    @waiting[Fiber.current] = current_time + duration
    # halt this fiber and transfer control to its parent
    Fiber.yield
    return true
  end

  def close
    run
  end

  private
  def current_time
    Process.clock_gettime(Process::CLOCK_MONOTONIC)
  end
end
