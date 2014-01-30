MongoClient = require('mongodb').MongoClient

exports.getFlipnoteInfo = (req, res) ->
  res.send '0\t0\t'

exports.getFlipnote = (req, res) ->
  flipnoteFile =req.params.flipnoteFile.substring(0, req.params.flipnoteFile.length - 4)
  MongoClient.connect("mongodb://127.0.0.1:27017/flipnote", (err, db) ->
    db.collection('flipnotes').findOne({editAuthorId: req.params.userId, currentFileName: flipnoteFile}, (err, result) ->

      if result
        res.send result.flipnote.buffer
      else
        console.log "Failed to find flipnote #{flipnoteFile} for user #{req.params.userId}"
        res.send "Failed to find flipnote"
      db.close()
    )
  )

exports.getFlipnoteDetails = (req, res) ->
  1

