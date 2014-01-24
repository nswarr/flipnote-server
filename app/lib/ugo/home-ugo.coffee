BufferWriter = require('../buffer-writer').BufferWriter
Ugo = require('./ugo').Ugo

links = [
  url: 'http://flipnote.hatena.com/ds/v2-us/movies/preferred.uls'
  text: 'All flipnotes'
  iconId: '102'
,
  url: 'http://flipnote.hatena.com/help/post_howto.htm'
  text: 'Post a note'
  iconId: '101'
]

class HomeUgo

  generate: =>
    w = new BufferWriter()
    w.write(Ugo.CONTENT_CATEGORY.LAYOUT).tab().write(Ugo.LAYOUT_TYPE.HOME_MENU).tab().write(1).newLine()

    w.write(Ugo.CONTENT_CATEGORY.TOP_SCREEN_TEXT).tab().write(0).newLine()

    links.forEach (link) ->
      w.write(Ugo.CONTENT_CATEGORY.LINK_BUTTON).tab().write(link.url).tab().write(link.iconId).tab()
      w.base64(link.text).tab().tab().write(0).newLine()

    content: w.getBuffer(), data: new Buffer(0)

exports.Ugo = HomeUgo