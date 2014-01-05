base64 = require('../lib/util').base64

BUFFER_SIZE = 1024 * 100

links = [
  url: 'http://flipnote.hatena.com/ds/v2-us/movies/preferred.uls'
  text: base64('All flipnotes')
  iconId: '102'
]

base64 = (str) ->
  new Buffer(str, 'utf8').toString('base64')

exports.index = (req, res) ->
  content = new Buffer(BUFFER_SIZE)
  contentPointer = 0
  contentPointer += content.write("0\t0\n")
  contentPointer += content.write("1\t0\t\t\t\t\t\n", 'utf8', contentPointer)

  links.forEach (link) ->
    linkItem = "4\t#{link.url}\t#{link.iconId}\t#{link.text}\t\t0"
    contentPointer +=content.write linkItem, 'utf8', contentPointer

  messageHeader = new Buffer(16)
  messageHeader.write("UGAR") #UGOs start with UGAR
  messageHeader.writeUInt32LE(0x00000002, 4) #Unknown
  messageHeader.writeUInt32LE(contentPointer, 8) #Write out the offset of the extra data, comes after the content

  #Extra data can be icons...not sure what else can be tucked in there yet
  extraData = new Buffer(1)
  extraData.writeUInt8(0, 0)

  console.log messageHeader

  response = Buffer.concat [messageHeader, content.slice(0, contentPointer), extraData]

  res.send response

