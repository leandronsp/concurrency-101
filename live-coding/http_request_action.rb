require 'async'
require 'uri'
require 'net/http'
require 'async/barrier'
require 'async/http/internet'
require 'typhoeus'

class HTTPRequestAction
  TIMES = 5.freeze

  def process_threads
    TIMES.times.map do
      Thread.new do
        uri = URI('https://httpbin.org/json')
        Net::HTTP.get(uri)
      end
    end.each(&:join)
  end

  def process_sync
    TIMES.times do
      uri = URI('https://httpbin.org/json')
      Net::HTTP.get(uri)
    end
  end

  def process_fibers
    reactor = Async::Reactor.new
    Fiber.set_scheduler(Async::Scheduler.new(reactor))

    Fiber.schedule do
      internet = Async::HTTP::Internet.new
      barrier = Async::Barrier.new

      TIMES.times.map do
        barrier.async do
          internet.get('https://httpbin.org/json')
        end
      end

      barrier.wait
    end

    reactor.run
  end

  def process_typhoeus
    hydra = Typhoeus::Hydra.new

    TIMES.times.map do
      http_request = Typhoeus::Request.new('https://httpbin.org/json', followlocation: true)
      hydra.queue(http_request)
    end

    hydra.run
  end
end
