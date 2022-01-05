const { PerformanceObserver, performance } = require('perf_hooks');
const { computation, times } = require('./computation')
const { fork } = require('child_process')
const { Worker } = require('worker_threads')

const observer = new PerformanceObserver((items) => {
  items.getEntries().forEach((entry) => {
    console.log(`${entry.name}: ${entry.duration / 1000.0} seconds`)
  })
  performance.clearMarks();
});

observer.observe({ type: 'measure' });
performance.measure('start')

performance.mark('sync');

times().forEach(() => {
  computation()
})

performance.measure('sync', 'sync');

performance.mark('forking');

times().forEach(() => {
  const child = fork('./cpu-bound/nodejs/child-process.js')
})

performance.measure('forking', 'forking');

performance.mark('workerthreads');

times().forEach(() => {
  const worker = new Worker('./cpu-bound/nodejs/worker-thread.js', {})
})

performance.measure('workerthreads', 'workerthreads');
