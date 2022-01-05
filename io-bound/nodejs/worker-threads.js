const { Worker } = require('worker_threads')
const { io, times } = require('./io')

const initialTime = Date.now()

times().forEach(() => {
  const worker = new Worker('./io-bound/nodejs/worker-thread.js', {})
})

console.log(`Done in ${(Date.now() - initialTime) / 1000.0} seconds`)
