StringDecoder = require('string_decoder').StringDecoder
decoder = new StringDecoder('ucs2')

exports.process = (ppmFile) ->
  results = {}
  metaData = {}
  results.metaData = metaData

  tmb = new Buffer(1696)
  tempBuffer = new Buffer(22)
  ppmFile.copy tmb, 0, 0, 1696
  results.tmb = tmb

  metaData.originalAuthor = getString(tmb.slice 0x0014, 0x002A)
  metaData.lastEditedBy =  getString(tmb.slice 0x002A, 0x0040)
  metaData.userName = getString(tmb.slice 0x0040, 0x0056)

  tempBuffer = tmb.slice 0x0056, 0x005E
  metaData.originalAuthorId = getFlipnoteId tempBuffer

  console.log metaData

getString = (buffer) ->
  endOfString = buffer.length - 1
  for index in [0..endOfString] by 2
    if buffer[index] == 0 && buffer[index+1] == 0
      endOfString = index
      break

  buffer.slice(0, endOfString).toString('utf16le')

getFlipnoteId = (buffer) ->
  temp = new Buffer(8)
  for index in [0..7]
    temp[index] = buffer[7 - index]

  temp.toString('hex').toUpperCase()
