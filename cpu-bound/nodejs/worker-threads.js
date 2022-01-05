const { Worker } = require('worker_threads')
const { computation, times } = require('./computation')

const initialTime = Date.now()

times().forEach(() => {
  const worker = new Worker('./cpu-bound/nodejs/worker-thread.js', {})
})

console.log(`Done in ${(Date.now() - initialTime) / 1000.0} seconds`)
