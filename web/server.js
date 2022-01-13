var net = require('net');

var server = net.createServer(client => {
  client.on('data', request => {
    console.log("Request: " + request)

    client.write("HTTP/2 200\r\nContent-Type: text/html\r\n\r\nNodeJS Yo!\n")
    client.end()
  })
})

server.listen(4000, '0.0.0.0', () => {
  console.log("Listening to the port 4000...")
})
