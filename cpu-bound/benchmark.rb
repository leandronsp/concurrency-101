require 'benchmark'
require './cpu-bound/computation'

def sync; times.times { computation }; end

def threads
  times.times.map { Thread.new { computation }}.each(&:join)
end

def fibers
  times.times.map { Fiber.new { computation }}.each(&:resume)
end

def forking
  times.times.map { fork { computation }}; Process.waitall
end

def ractors
  times.times.map { Ractor.new { computation }}.each(&:take)
end

Benchmark.bm do |x|
  x.report('sync')    {  sync    }
  x.report('threads') {  threads }
  x.report('fibers')  {  fibers  }
  x.report('forking') {  forking }
  x.report('ractors') {  ractors }
end
