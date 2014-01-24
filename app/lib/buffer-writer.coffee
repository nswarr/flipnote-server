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
    @buffer.slice(0, @bytesWritten)

exports.BufferWriter = BufferWriter