fs = require 'fs'

exports.postFlipnote = (req, res) ->

  # get metadata
  # verify expected data is there
  # save file somewhere (FS?  Somewhere else?)
  # save metadata to DB with path to file


  data = new Buffer('')
  req.on 'data', (chunk) ->
    data = Buffer.concat [data, chunk]
  req.on 'end', () ->
#    fd = fs.openSync "#{process.cwd()}/mish_flipnote.ppm", 'w'
#    fs.writeSync fd, data, 0, data.length
    res.send "ok"

