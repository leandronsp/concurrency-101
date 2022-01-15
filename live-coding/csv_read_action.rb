require 'csv'
require 'async'

class CSVReadAction
  TIMES = 30.freeze
  SLICE = 1_000.freeze

  def initialize
    @response = 0
  end

  def process
    ractors = []

    (1..TIMES).each_slice(8) do |slice|
      puts "Ractor ID: #{Ractor.current.object_id}"

      ractors << Ractor.new(slice) do |slice|
        chunks = []

        slice.map do |id|
          Thread.new do
            File.open("./live-coding/files/users_#{id}.csv") do |file|
              file.lazy.each_slice(SLICE) do |slice|
                chunks << CSV.parse(slice.join)
              end
            end
          end
        end.each(&:join)

        chunks
      end
    end

    @response = ractors
      .map(&:take)
      .flatten(2)
      .map(&:last)
      .map(&:to_i)
      .sum
  end

  def process_sync
    chunks = []

    TIMES.times do |idx|
      File.open("./live-coding/files/users_#{idx + 1}.csv") do |file|
        file.lazy.each_slice(SLICE) do |slice|
          chunks << CSV.parse(slice.join)
        end
      end
    end

    @response = chunks
      .flatten(1)
      .map(&:last)
      .map(&:to_i)
      .sum
  end

  def process_threads
    chunks = []

    TIMES.times.map do |idx|
      Thread.new do
        File.open("./live-coding/files/users_#{idx + 1}.csv") do |file|
          file.lazy.each_slice(SLICE) do |slice|
            chunks << CSV.parse(slice.join)
          end
        end
      end
    end.each(&:join)

    @response = chunks
      .flatten(1)
      .map(&:last)
      .map(&:to_i)
      .sum
  end

  def process_fibers
    reactor = Async::Reactor.new
    Fiber.set_scheduler(Async::Scheduler.new(reactor))

    chunks = []

    TIMES.times.map do |idx|
      Fiber.schedule do
        File.open("./live-coding/files/users_#{idx + 1}.csv") do |file|
          file.lazy.each_slice(SLICE) do |slice|
            chunks << CSV.parse(slice.join)
          end
        end
      end
    end

    reactor.run

    @response = chunks
      .flatten(1)
      .map(&:last)
      .map(&:to_i)
      .sum
  end

  def process_ractors
    ractors = []

    TIMES.times.map do |idx|
      File.open("./live-coding/files/users_#{idx + 1}.csv") do |file|
        file.lazy.each_slice(SLICE) do |slice|
          ractors << Ractor.new(slice) do |inner_slice|
            CSV.parse(inner_slice.join)
          end
        end
      end
    end

    @response = ractors
      .map(&:take)
      .flatten(1)
      .map(&:last)
      .map(&:to_i)
      .sum
  end

  def response
    @response
  end
end
