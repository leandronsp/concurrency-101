require 'benchmark'
require 'async'
require './io-bound/io'
require './lib/fiber-scheduler'

def sync; times.times { io }; end

def threads
  times.times.map { Thread.new { io }}.each(&:join)
end

def fibers
  #reactor = Async::Reactor.new
  #scheduler = Async::Scheduler.new(reactor)
  #Fiber.set_scheduler scheduler

  times.times.map { Fiber.new { io }}.each(&:resume)

  #reactor.run
end

def forking
  times.times.map { fork { io }}; Process.waitall
end

def ractors
  times.times.map { Ractor.new { io }}.each(&:take)
end

Benchmark.bm do |x|
  x.report('sync')    {  sync    }
  x.report('threads') {  threads }
  x.report('fibers')  {  fibers  }
  x.report('forking') {  forking }
  x.report('ractors') {  ractors }
end
