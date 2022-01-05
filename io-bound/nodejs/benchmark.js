const { PerformanceObserver, performance } = require('perf_hooks');
const { io, times } = require('./io')
const { fork } = require('child_process')
const { Worker } = require('worker_threads')
const { exec } = require("child_process");

const observer = new PerformanceObserver((items) => {
  items.getEntries().forEach((entry) => {
    console.log(`${entry.name}: ${entry.duration / 1000.0} seconds`)
  })
  performance.clearMarks();
});

observer.observe({ type: 'measure' });

performance.mark('sync');

times().forEach(() => { io() })

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

performance.mark('asyncio');

times().forEach(() => {
  exec('sleep 0.005')
})

performance.measure('asyncio', 'asyncio');
