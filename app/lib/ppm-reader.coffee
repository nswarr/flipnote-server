exports.process = (ppmFile) ->
  tmb = ppmFile.slice 0, 1696

  metaData = {}
  metaData.originalAuthor = getString(tmb.slice 0x0014, 0x002A)
  metaData.lastEditedBy =  getString(tmb.slice 0x002A, 0x0040)
  metaData.userName = getString(tmb.slice 0x0040, 0x0056)
  metaData.originalAuthorId = getFlipnoteId(tmb.slice 0x0056, 0x005E)
  metaData.editAuthorId = getFlipnoteId(tmb.slice 0x005E, 0x0066)
  metaData.originalFileName = getFileName(tmb.slice 0x0066, 0x0078)
  metaData.currentFileName = getFileName(tmb.slice 0x0078, 0x008A)
  metaData.previousEditAuthorId = getFlipnoteId(tmb.slice 0x008A, 0x0092)
  metaData.partialFileName = tmb.slice(0x0092, 0x009A).toString('hex').toUpperCase()
  metaData.secondsSince2000 = tmb.readUInt32LE 0x009A

  tmb: tmb, metaData: metaData

getString = (buffer) ->
  endOfString = buffer.length - 1
  for index in [0..endOfString] by 2
    if buffer[index] == 0 && buffer[index+1] == 0
      endOfString = index
      break

  buffer.slice(0, endOfString).toString('utf16le')

#Have to read it out backwards
getFlipnoteId = (buffer) ->
  bufferLength = buffer.length
  temp = new Buffer(bufferLength)
  for index in [0..(bufferLength - 1)]
    temp[index] = buffer[(bufferLength - 1) - index]

  temp.toString('hex').toUpperCase()


getFileName = (buffer) ->
  prefix = buffer.slice(0, 3).toString('hex').toUpperCase()
  fileName = buffer.slice(3, 16).toString 'utf8'
  version = "000#{buffer.readUInt16LE(16).toString()}".slice -3

  "#{prefix}_#{fileName}_#{version}"