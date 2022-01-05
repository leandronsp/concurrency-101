const { workerData, parentPort } = require('worker_threads')
const { io } = require('./io')

io()
