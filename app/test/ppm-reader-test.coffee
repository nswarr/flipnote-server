reader = require '../lib/ppm-reader'
fs = require 'fs'

console.log process.cwd()

data = fs.readFileSync './app/test/39F150_0D2554AA404AD_006.ppm'

results = reader.process data
