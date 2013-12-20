express = require 'express'
app = express()

app.get '/', (req, res) ->
   res.sendfile 'dev/index.html'

app.configure ->
   app.use '/', express.static (__dirname + '/dev')

app.listen 8080

console.log 'listening on port 8080'
