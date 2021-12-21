class Processor
  def self.process(job)
    action = job[:action]
    args   = job[:args]

    action.call(*args)
  end

  def self.process_sync(queue)
    while queue.length > 0
      job = queue.deq

      self.process(job)
    end
  end

  def self.process_threads(queue)
    threads = Array.new(queue.length) do
      Thread.new do
        job = queue.deq

        self.process(job)
      end
    end

    threads.each(&:join)
  end

  def self.process_fibers(queue)
    fibers = Array.new(queue.length) do
      Fiber.new do
        job = queue.deq

        self.process(job)
      end
    end

    fibers.each(&:resume)
  end

  def self.process_forking(queue)
    while queue.length > 0
      job = queue.deq

      fork do
        self.process(job)
      end
    end

    Process.waitall
  end

  def self.process_ractors(queue)
    ractors = Array.new(queue.length) do
      job = queue.deq

      Ractor.new(job) do |job|
        Processor.process(job)
      end
    end

    ractors.map(&:take)
  end
end
