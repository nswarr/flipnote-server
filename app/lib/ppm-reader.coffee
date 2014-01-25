exports.process = (ppmFile) ->
  tmb = ppmFile.slice 0, 1696

  flipDoc = {tmb: tmb, flipnote: ppmFile}
  flipDoc.originalAuthor = getString(tmb.slice 0x0014, 0x002A)
  flipDoc.lastEditedBy =  getString(tmb.slice 0x002A, 0x0040)
  flipDoc.userName = getString(tmb.slice 0x0040, 0x0056)
  flipDoc.originalAuthorId = getFlipnoteId(tmb.slice 0x0056, 0x005E)
  flipDoc.editAuthorId = getFlipnoteId(tmb.slice 0x005E, 0x0066)
  flipDoc.originalFileName = getFileName(tmb.slice 0x0066, 0x0078)
  flipDoc.currentFileName = getFileName(tmb.slice 0x0078, 0x008A)
  flipDoc.previousEditAuthorId = getFlipnoteId(tmb.slice 0x008A, 0x0092)
  flipDoc.partialFileName = tmb.slice(0x0092, 0x009A).toString('hex').toUpperCase()
  flipDoc.secondsSince2000 = tmb.readUInt32LE 0x009A

  flipDoc

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