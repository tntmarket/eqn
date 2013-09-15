express = require('express')
app = express()

app.get('/', (req, res) ->
   res.sendfile('app/index.html')
)

app.configure( ->
   app.use(express.static(__dirname + '/app'))
)

app.listen(8080)

console.log('listening on port 8080')

