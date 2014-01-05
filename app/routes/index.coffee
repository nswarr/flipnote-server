UGAR = [0x55, 0x47, 0x41, 0x52]
UNKNOWN_AFTER_UGAR = [0x02, 0x00, 0x00, 0x00]
BUFFER_SIZE = 1024 * 100

links = [
  url: 'http://flipnote.hatena.com/ds/v2-eu/movies/preferred.uls'
  text: 'QwBoAGEAbgBuAGUAbABzAA=='
  iconId: '102'
]


exports.index = (req, res) ->
  content = new Buffer(BUFFER_SIZE)
  contentSize = 0
  contentSize += content.write("0\t0\n")
  contentSize += content.write("1\t0\t\t\t\t\t\n", 'utf8', contentSize)

  links.forEach (link) ->
    linkItem = "4\t#{link.url}\t#{link.iconId}\t#{link.text}\t\t0"
    contentSize +=content.write linkItem, 'utf8', contentSize

  messageHeader = new Buffer(16)
  messageHeader.write("UGAR") #UGAR
  messageHeader.writeUInt32LE(0x00000002, 4) #Unknown
  messageHeader.writeUInt32LE(contentSize, 8) #Write out the offset of the extra data, comes after the content

  extraData = new Buffer(1)
  extraData.writeUInt8(0, 0)

  response = Buffer.concat [messageHeader, content.slice(0, contentSize), extraData]

  res.send response

