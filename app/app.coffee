express = require("express")
routes = require("./routes")
postFlipnote = require("./routes/post-flipnote").postFlipnote
user = require("./routes/user")
http = require("http")
path = require("path")
app = express()
app.configure ->
  app.set "port", process.env.PORT or 7171
  app.set "views", __dirname + "/views"
  app.set 'view engine', 'ugo'    # use .html extension for templates
  app.engine 'ugo', require('./lib/hogan-express')
  app.use express.favicon()
  app.use express.cookieParser()
  app.use express.logger("dev")
  app.use express.methodOverride()
  app.use app.router
  app.use express.static(path.join(__dirname, "public"))

app.configure "development", ->
  app.use express.errorHandler()

app.get "/", routes.index
app.get "/ds/v2-us/index.ugo", routes.index
app.post "/ds/v2/ch/flipnote.post", postFlipnote

http.createServer(app).listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")