require 'benchmark'
require './lib/fib-sequence'
require './lib/synchronized-queue'
require './batch-processing/processor'

puts "Main process: #{Process.pid}"

# enqueue

def build_queue
  queue = SynchronizedQueue.new

  150.times do
    queue.enq({ action: FibSequence, args: [30] })
  end

  queue
end

# processing

Benchmark.bm do |x|
  x.report('process sync') { Processor.process_sync(build_queue) }
  x.report('process threads') { Processor.process_threads(build_queue) }
  x.report('process fibers') { Processor.process_fibers(build_queue) }
  x.report('process forking') { Processor.process_forking(build_queue) }
  x.report('process ractors') { Processor.process_ractors(build_queue) }
end
