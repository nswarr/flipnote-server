exports.base64 = (str) ->
   new Buffer(str, 'utf16le').toString('base64')