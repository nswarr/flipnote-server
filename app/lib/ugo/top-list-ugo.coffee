BufferWriter = require('../buffer-writer').BufferWriter

CONTENT_CATEGORY =
  LAYOUT: 0
  TOP_SCREEN_TEXT: 1
  FILTER_ITEM: 2
  PREVIEW_BUTTON: 4

LAYOUT_TYPE =
  FLIPNOTE_PREVIEW: 2

class TopListUgo
  constructor: ->
    @dropDownFilters = []
    @flipnotePreviews = []

  addTopScreenText: (config) =>
    @topScreenConfig = config

  addDropDownFilter: (url, text, isSelected) =>
    @dropDownFilters.push url: url, text: text, isSelected: isSelected

  addFlipnotePreview: (flipnoteHeader) =>
    @flipnotePreviews.push flipnoteHeader

  generate: =>
    w = new BufferWriter()
    dataSections = []
    w.write(CONTENT_CATEGORY.LAYOUT).tab().write(LAYOUT_TYPE.FLIPNOTE_PREVIEW).tab().write(1).newLine()

    if @topScreenConfig
      w.write(CONTENT_CATEGORY.TOP_SCREEN_TEXT).tab().write(0).tab()
      w.base64(@topScreenConfig.title).tab()
      w.tab().base64(@topScreenConfig.leftSubtitle) if @topScreenConfig.leftSubtitle
      w.tab().base64(@topScreenConfig.rightSubtitle) if @topScreenConfig.rightSubtitle
      w.tab().base64(@topScreenConfig.bottomText).tab() if @topScreenConfig.bottomText
      w.newLine()

    @dropDownFilters.forEach (filter) =>
      w.write(CONTENT_CATEGORY.FILTER_ITEM).tab().write(filter.url).tab().base64(filter.text).tab()
      if filter.isSelected
        w.write(1)
      else
        w.write(0)

    @flipnotePreviews.forEach (header) =>
      w.newLine()
      w.write(CONTENT_CATEGORY.PREVIEW_BUTTON).tab()
      w.write("http://flipnote.hatena.com/flipnote/#{header.editAuthorId}/#{header.currentFileName}.ppm").tab()
      w.write(3).tab().tab().write(0).tab()
      w.write(765).tab().write(573).tab().write(0)

      dataSections.push header.tmb.buffer

    content: w.getBuffer(), data: Buffer.concat(dataSections)

exports.Ugo = TopListUgo