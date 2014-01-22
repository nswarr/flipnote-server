fs = require 'fs'
ppmReader = require '../lib/ppm-reader'
MongoClient = require('mongodb').MongoClient

exports.postFlipnote = (req, res) ->
  data = new Buffer('')
  req.on 'data', (chunk) ->
    data = Buffer.concat [data, chunk]
  req.on 'end', () ->
#    fd = fs.openSync "#{process.cwd()}/mish_flipnote.ppm", 'w'
#    fs.writeSync fd, data, 0, data.length
    results = ppmReader.process data

    MongoClient.connect("mongodb://127.0.0.1:27017/flipnote", (err, db) ->
      db.collection('flipnotes').insert results, (err, records) ->
        console.log records
      res.send "ok"
    )



