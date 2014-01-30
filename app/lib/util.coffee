exports.base64 = (str) ->
   new Buffer(str, 'utf16le').toString('base64')

exports.logHeaders = (req, res, next) ->
  console.log req.headers
  next()