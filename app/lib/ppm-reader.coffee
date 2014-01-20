exports.process = (ppmFile) ->
  results = {}
  metaData = {}
  results.metaData = metaData

  tmb = new Buffer(1696)
  tempBuffer = new Buffer(22)
  ppmFile.copy tmb, 0, 0, 1696
  results.tmb = tmb

  tempBuffer = tmb.slice 0x0014, 0x002A
  metaData.originalAuthor = tempBuffer.toString('utf16le')

  tempBuffer = tmb.slice 0x002A, 0x0040
  metaData.lastEditedBy = tempBuffer.toString('utf16le')

  tempBuffer = tmb.slice 0x0040, 0x0056
  metaData.userName = tempBuffer.toString('utf16le')

  tempBuffer = tmb.slice 0x0056, 0x005E
  flipnoteIdBin = tempBuffer.slice(0,8)

  metaData.originalAuthorId = tempBuffer.slice(0,8).toString('hex')

  console.log metaData



