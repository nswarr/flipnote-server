exports.render = (ugo) ->

  compiledUgo = ugo.generate()

  header = new Buffer(16)
  header.write("UGAR")
  header.writeUInt32LE(0x00000002, 4) #Number of sections
  header.writeUInt32LE(compiledUgo.content.length, 8) #Write out the offset of the extra data, comes after the content
  header.writeUInt32LE(compiledUgo.data.length, 8) #Write out the offset of the extra data, comes after the content

  Buffer.concat [header, compiledUgo.content, compiledUgo.data]
