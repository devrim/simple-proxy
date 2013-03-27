http = require 'http'

console.log "hit starts..."
for i in [0..100]
  console.log "hitting proxy nr:#{i}"
  http.get "http://0.local:8001",(res)->
    # console.log res.body
setInterval ->
	console.log '.'
,1000