TopList = require('../lib/ugo/top-list-ugo').Ugo
renderer = require('../lib/ugo-renderer')
MongoClient = require('mongodb').MongoClient

exports.toplistIndex = (req, res) ->
  ugo = new TopList()

  ugo.addTopScreenText(
    title: "Top List"
  )
  ugo.addDropDownFilter("http://flipnote.hatena.com/ds/v2-us/hotmovies.uls", "Hot!", true)

  MongoClient.connect("mongodb://127.0.0.1:27017/flipnote", (err, db) ->
    db.collection('flipnotes').find({}, {limit:50}).toArray((err, results) ->
      results.forEach (result) ->
        ugo.addFlipnotePreview(result)

      res.send renderer.render(ugo)
      db.close()
    )
  )
