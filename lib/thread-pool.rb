class ThreadPool
  attr_reader :queue

  def initialize(size)
    @size = size
    @jobs = Queue.new
    @pool = Array.new(size) do
      Thread.new do
        catch(:exit) do
          loop do
            job = @jobs.pop
            job.call
          end
        end
      end
    end
  end

  def perform(&block)
    @jobs << block
  end

  def shutdown
    @size.times do
      perform { throw :exit }
    end

    @pool.map(&:join)
  end
end
