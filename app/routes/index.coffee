HomeUgo = require('../lib/ugo/home-ugo').Ugo
renderer = require('../lib/ugo-renderer')

exports.index = (req, res) ->
  res.send renderer.render(new HomeUgo())

