base64 = require('../lib/util').base64

BUFFER_SIZE = 1024 * 100

links = [
  url: 'http://flipnote.hatena.com/ds/v2-us/movies/preferred.uls'
  text: base64('All flipnotes')
  iconId: '102'
,
  url: 'http://flipnote.hatena.com/ds/v2-us/test-page.htm'
  text: base64('Check this out Mishka!')
  iconId: '101'
]

base64 = (str) ->
  new Buffer(str, 'utf8').toString('base64')

exports.index = (req, res) ->
  content = new Buffer(BUFFER_SIZE)
  contentByteCount = 0
  contentByteCount += content.write("0\t0\n")
  contentByteCount += content.write("1\t0\t\t\t\t\t\n", 'utf8', contentByteCount)

  links.forEach (link) ->
    linkItem = "4\t#{link.url}\t#{link.iconId}\t#{link.text}\t\t0\n"
    contentByteCount +=content.write linkItem, 'utf8', contentByteCount

  if contentByteCount % 4 != 0
    paddingSize = 4 - contentByteCount % 4
    switch paddingSize
      when 1
        content.writeUInt8(0x00, contentByteCount)
      when 2
        content.writeUInt16LE(0x00, contentByteCount)
      when 3
        content.writeUInt8(0x00, contentByteCount)
        content.writeUInt16LE(0x00, contentByteCount + 1)
    contentByteCount += paddingSize

  messageHeader = new Buffer(16)
  messageHeader.write("UGAR") #UGOs start with UGAR
  messageHeader.writeUInt32LE(0x00000002, 4) #Unknown
  messageHeader.writeUInt32LE(contentByteCount, 8) #Write out the offset of the extra data, comes after the content

  #Extra data can be icons...not sure what else can be tucked in there yet
  extraData = new Buffer(1)
  extraData.writeUInt8(0, 0)

  console.log messageHeader

  response = Buffer.concat [messageHeader, content.slice(0, contentByteCount), extraData]

  res.send response

