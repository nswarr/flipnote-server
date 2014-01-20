reader = require '../lib/ppm-reader'
fs = require 'fs'

console.log process.cwd()

data = fs.readFileSync './app/test/mish_flipnote.ppm'

results = reader.process data
