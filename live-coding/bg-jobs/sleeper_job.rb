class SleeperJob
  def initialize(*args)
    @args = args
    @times, @amount = @args
  end

  def perform
    @times.times do
      sleep @amount
    end
  end

  def to_s
    "#{self.class.name} ID #{self.object_id} with args #{@args}"
  end
end
