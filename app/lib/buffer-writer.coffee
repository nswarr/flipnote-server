toBase64 = require('../lib/util').base64

BUFFER_SIZE = 1024 * 10

class BufferWriter
  constructor: (bufferSize) ->
    @buffer = new Buffer(bufferSize || BUFFER_SIZE)
    @bytesWritten = 0

  base64: (str) =>
    @bytesWritten += @buffer.write(toBase64(str), @bytesWritten)
    @

  write: (item) =>
    @bytesWritten += @buffer.write("#{item}", @bytesWritten)
    @

  tab: =>
    @bytesWritten += @buffer.write("\t", @bytesWritten)
    @

  newLine: =>
    @bytesWritten += @buffer.write("\n", @bytesWritten)
    @

  getBuffer: =>
    if @bytesWritten % 4 != 0
      paddingSize = 4 - @bytesWritten % 4
      switch paddingSize
        when 1
          @buffer.writeUInt8(0x00, @bytesWritten)
        when 2
          @buffer.writeUInt16LE(0x0000, @bytesWritten)
        when 3
          @buffer.writeUInt8(0x00, @bytesWritten)
          @buffer.writeUInt16LE(0x0000, @bytesWritten + 1)
    @bytesWritten += paddingSize || 0

    @buffer.slice(0, @bytesWritten)

exports.BufferWriter = BufferWriter