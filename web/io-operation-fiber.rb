require 'async'
require 'async/barrier'
require 'async/http/internet'

class IOOperationFiber
  def self.call
    do_some_io
    #do_external_request
  end

  private

  def self.do_some_io
    20.times do
      Fiber.schedule do
        sleep 0.0005
      end
    end
  end

  def self.do_external_request
    internet = Async::HTTP::Internet.new
    barrier = Async::Barrier.new

    5.times do
      barrier.async do
        internet.get('https://httpbin.org/json')
      end
    end

    barrier.wait
  end
end
