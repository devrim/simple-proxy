bouncy = require "bouncy"
express = require "express"
request = require 'request'
nextHost = (key)->
  last    = routingTable[key].lastBounce 
  length  = routingTable[key].hosts.length
  next    = (last+1)%(length)
  routingTable[key].lastBounce = next
  console.log next,routingTable[key].hosts[next]
  return routingTable[key].hosts[next]

server = bouncy((req, res, bounce) ->
  r = req.headers.host
  if routingTable[r]
    n = nextHost r 
    console.log "bouncing #{r} to #{n}"
    # res.end "bouncing #{r} to #{n}"
    bounce n
    
  else
    console.log a = "#{r} no such host."
    res.end a
)
server.listen 8001
console.log "proxy server is on at port 8001"

routingTable = {}
app      = express()
app.configure ->
  app.set 'case sensitive routing', on
  app.use express.cookieParser()
  app.use express.session {"secret":"foo"}


app.get "/add/:key/:host", (req, res)->
  {key,host}  = req.params
  routingTable[key] or= {}
  routingTable[key].hosts or= []
  routingTable[key].lastBounce or= 0
  routingTable[key].hosts.push host

  res.send routingTable

app.listen 8002
console.log "proxy api is on at port 8002"

# EXAMPLE WEBSERVERS
http = require('http')
for i in [1330...1340]
  do (i)->
    http.createServer((req, res) ->
      res.writeHead 200,
        "Content-Type": "text/plain"

      res.end "Hello World from server at port:#{i}\n"
    ).listen i, "127.0.0.1"
    # add self to proxy
    aa = "http://0.local:8002/add/0.local:8001/127.0.0.1:#{i}"
    http.get aa,->
      console.log "registered #{aa}"
    console.log "example server is on at port #{i}"






