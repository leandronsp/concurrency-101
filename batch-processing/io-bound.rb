require 'benchmark'
require './lib/sleeper'
require './lib/my-queue'
require './batch-processing/processor'

puts "Main process: #{Process.pid}"

# enqueue

def build_queue
  (1..8).inject(MyQueue.new) do |acc, idx|
    acc.enq({ action: Sleeper, args: [idx, 0.5] })
    acc
  end
end

# processing

Benchmark.bm do |x|
  x.report('process sync') { Processor.process_sync(build_queue) }
  x.report('process threads') { Processor.process_threads(build_queue) }
  x.report('process fibers') { Processor.process_fibers(build_queue) }
  x.report('process forking') { Processor.process_forking(build_queue) }
  x.report('process ractors') { Processor.process_ractors(build_queue) }
end