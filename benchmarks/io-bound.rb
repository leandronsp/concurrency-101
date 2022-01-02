require 'benchmark'
require './lib/sleeper'
require './lib/synchronized-queue'
require './batch-processing/processor'

puts "Main process: #{Process.pid}"

# enqueue

def build_queue
  queue = SynchronizedQueue.new

  1_000.times do
    queue.enq({ action: Sleeper, args: [0.005] })
  end

  queue
end

# processing

Benchmark.bm do |x|
  x.report('process sync') { Processor.process_sync(build_queue) }
  x.report('process threads') { Processor.process_threads(build_queue) }
  x.report('process fibers') { Processor.process_fibers(build_queue) }
  x.report('process fibers with scheduler') { Processor.process_fibers_with_scheduler(build_queue) }
  x.report('process forking') { Processor.process_forking(build_queue) }
  x.report('process ractors') { Processor.process_ractors(build_queue) }
end
