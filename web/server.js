var net = require('net');

var server = net.createServer(client => {
  client.on('data', request => {
    const requestRegex = /GET\s(.*)\sHTTP\/1\.1/;
    const requestFound = request.toString().match(requestRegex);

    if (requestFound !== null && requestFound[1] == "/") {
      console.log(`Request: ${request}`)

      const cookie = {}
      const cookieRegex = /Cookie:\s(.*)=(.*)/;
      const cookieFound = request.toString().match(cookieRegex);

      if (cookieFound !== null) {
        cookie[cookieFound[1]] = cookieFound[2]
      }

      const counter = Number(cookie?.counter || 0) + 1

      const response =
`HTTP/2 200\r\n\
Content-Type: text/html\r\n\
Set-Cookie: counter=${counter}; path=/; HttpOnly\r\n\
Cache-Control: max-age=5\r\n\
\r\n\
<h1>Counter: ${counter}</h1>
<br />
<a href="javascript:location.reload(true)">Reload with refresh</a>
<br />
<a href="/">Reload</a>\n`

      client.write(response)
    }

    client.end()
  })
})

server.listen(4000, '0.0.0.0', () => {
  console.log("Listening to the port 4000...")
})
