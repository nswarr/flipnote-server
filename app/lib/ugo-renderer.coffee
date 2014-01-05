fs = require 'fs'

exports.render = (path, options, fn) ->
  fs.readFile path, 'ucs2' ,(err, str) ->
    return fn(err) if (err)
    # Remove potential UTF Byte Order Mark
    str = str.replace(/^\uFEFF/, '')
    cache[path] = str if (options.cache)
    fn(null, str)