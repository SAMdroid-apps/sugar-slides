define (require) ->
  require 'jquery'
  Scribe = require 'scribe'
  scribePluginToolbar = require 'plugins/scribe-plugin-toolbar'
  scribePluginHeadingCommand = require 'plugins/scribe-plugin-heading-command'
  set_context_menu_postion = require 'activity/menu'

  do_selection_menu = (event) ->
    if not $('#main-toolbar').hasClass 'hidden'
      event = event || window.event
      popover = $ '.scribe-toolbar'

      pos = set_context_menu_postion event, popover
      popover.css 'top': pos.y
      popover.css 'left', pos.x
      popover.fadeIn()

      $('body').one 'click', ->
        popover.fadeOut()

  obj = {}

  obj.setup_slide = (ele) ->
    s = new Scribe ele[0], { allowBlockElements: true }
    s.use scribePluginHeadingCommand(1)
    s.use scribePluginHeadingCommand(2)
    s.use scribePluginToolbar(document.querySelector '.scribe-toolbar')
    ele.attr 'contenteditable', 'true'

  obj.setup = ->
    eles = $ 'section'
    eles.each ->
      obj.setup_slide $(this)

  obj.setup_once = ->
    $('button#format').click ->
      popover = $ '.scribe-toolbar'
      if this.palette_is_up || false
        popover.hide()
        this.palette_is_up = false
      else
        pos = $(this).position()
        pos.top += $(this).outerWidth() - 2
        pos.left -= 10

        popover.css 'top': pos.top
        popover.css 'left', pos.left
        popover.show()
        this.palette_is_up = true

    $('.slides').on 'contextmenu', (event) ->
      if event.toElement.tagName == 'IMG'
        return
      event.preventDefault()
      do_selection_menu()

  obj
