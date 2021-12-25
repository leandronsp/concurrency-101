require 'net/http'

class IOOperationThreaded
  def self.call
    do_some_io
    #do_external_request
  end

  private

  def self.do_some_io
    threads = []

    20.times do
      threads << Thread.new do
        sleep 0.0005
      end
    end

    threads.each(&:join)
  end

  def self.do_external_request
    threads = []

    5.times do
      threads << Thread.new do
        uri = URI('https://httpbin.org/json')
        Net::HTTP.get(uri)
      end
    end

    threads.each(&:join)
  end
end
