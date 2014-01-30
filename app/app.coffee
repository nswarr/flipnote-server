express = require("express")
routes = require("./routes")
logHeaders = require('./lib/util').logHeaders
postFlipnote = require("./routes/post-flipnote").postFlipnote
flipnoteShow = require("./routes/get-flipnote")
toplistIndex = require("./routes/top-list").toplistIndex
http = require("http")
path = require("path")
app = express()

app.param (name, fn) ->
  if fn instanceof RegExp
    (req, res, next, val) ->
      captures = undefined
      if captures = fn.exec(String(val))
        req.params[name] = captures[0]
        next()
      else
        next "route"

app.configure ->
  app.set "port", process.env.PORT or 7171
  app.set "views", __dirname + "/views"
  app.use express.favicon()
  app.use logHeaders
  app.use express.logger("dev")
  app.use express.cookieParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static(path.join(__dirname, "public"))

app.configure "development", ->
  app.use express.errorHandler()

app.param 'userId', /([0-9]|[A-F])+/
app.param 'flipnoteInfo', /([0-9]|_|[A-F])+\.info/
app.param 'flipnoteFile', /([0-9]|_|[A-F])+\.ppm/

app.get "/", routes.index
app.get '/flipnote/:userId/:flipnoteInfo', flipnoteShow.getFlipnoteInfo
app.get "/flipnote/:userId/:flipnoteFile", flipnoteShow.getFlipnote
app.get "/ds/v2-us/index.ugo", routes.index
app.post "/flipnote.post", postFlipnote
app.get "/ds/v2-us/movies/preferred.ugo", toplistIndex

http.createServer(app).listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")