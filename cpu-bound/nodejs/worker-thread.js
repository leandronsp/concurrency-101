const { workerData, parentPort } = require('worker_threads')
const { computation } = require('./computation')

computation()
