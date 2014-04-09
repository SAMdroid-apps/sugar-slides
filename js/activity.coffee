MIN_TOUCH_DISTANCE = 400

define (require) ->
  activity = require 'sugar-web/activity/activity'
  dictstore = require 'sugar-web/dictstore'

  set_context_menu_postion = require 'activity/menu'
  themes = require 'activity/themes'
  img = require 'activity/img'
  cloud = require 'activity/cloud'

  require 'jquery'
  Scribe = require 'scribe'
  scribePluginToolbar = require 'plugins/scribe-plugin-toolbar'
  scribePluginHeadingCommand = require 'plugins/scribe-plugin-heading-command'
 
  container = $ '.slides'
 
  activity.setup()

  do_bar = ->
    bar = $ '.bar'
    x = ($('section.seen').length) / ($('section').length - 1)
    bar.css 'width', "#{ x * 100 }%"

  next_slide = ->
    slides = $ 'section.to-see', container
    if slides.length == 0
      return

    center = $ 'section:not(.to-see, .seen)', container
    center.addClass 'seen'

    slide = $ slides[0]
    slide.removeClass 'to-see'

    do_bar()

  prev_slide = ->
    slides = $ 'section.seen', container
    if slides.length == 0
      return

    center = $ 'section:not(.to-see, .seen)', container
    center.addClass 'to-see'

    slide = $ slides[slides.length - 1]
    slide.removeClass 'seen'

    do_bar()

  add_slide = ->
    ele = $ "<section class='to-see'>
               <h1>New Slide</h1>
               <p>Lets type and make a new slide</p>
             </section>"
    center = $ 'section:not(.to-see, .seen)', container
    ele.insertAfter center
    scribe_setup_slide ele
    next_slide()

    do_bar()

  remove_slide = ->
    center = $ 'section:not(.to-see, .seen)', container
    center.remove()

    slides = $ 'section'
    if slides.length == 0
      container.html "<section>
               <h1>New Slide</h1>
               <p>Lets type and make a new slide</p>
                      </section>"
      scribe_setup_slide($ 'section', container)
    else
      slides = $ 'section.to-see', container
      if slides.length > 0
        next_slide()
      else
        prev_slide()

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

  scribe_setup_slide = (ele) ->
    s = new Scribe ele[0], { allowBlockElements: true }
    s.use scribePluginHeadingCommand(1)
    s.use scribePluginHeadingCommand(2)
    s.use scribePluginToolbar(document.querySelector '.scribe-toolbar')
    ele.attr 'contenteditable', 'true'

  scribe_setup = ->
    eles = $ 'section'
    eles.each ->
      scribe_setup_slide $(this)


  d = $ 'document'
  d.ready ->
    container.on 'contextmenu', (event) ->
      if event.toElement.tagName == 'IMG'
        return
      event.preventDefault()
      do_selection_menu()

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

    $('button#n').click ->
      next_slide()

    $('button#p').click ->
      prev_slide()

    touch_starts = {}
    container[0].addEventListener 'touchstart', (event) ->
      t = event.touches[event.which]
      touch_starts[event.which] = {x: t.clientX, y: t.clientY, can_do: true}

    container[0].addEventListener 'touchmove', (event) ->
      event.preventDefault()
      t = event.touches[event.which]
      s = touch_starts[event.which]

      #  Quick and wrong maths
      distance = Math.abs(t.clientX - s.x) + Math.abs(t.clientY - s.y)
      if distance > MIN_TOUCH_DISTANCE and s.can_do == true
        s.can_do = false
        if (t.clientX - s.x) > 0
          prev_slide()
        else
          next_slide()

    container[0].addEventListener 'touchend', (event) ->
      touch_starts[event.which] = {}

    $('button#add').click ->
      add_slide()

    $('button#img').click ->
      activity.showObjectChooser img.callback

    $('button#remove').click ->
      if confirm 'Delete the current slide?'
        remove_slide()

    $('button#fullscreen').click ->
      $('#main-toolbar').addClass 'hidden'
      $('button#unfullscreen').show()
      $(this).hide()
      
      eles = $ 'section'
      eles.each ->
        $(this).attr 'contenteditable', 'false'

    $('button#unfullscreen').click ->
      $('#main-toolbar').removeClass 'hidden'
      $('button#fullscreen').show()
      $(this).hide()
      scribe_setup()

    $('body').keyup (event) ->
      # Key shortcuts only if the user is not editing or fullscreen
      if document.activeElement.nodeName == "BODY" or
                               $('#main-toolbar').hasClass 'hidden'
        if event.keyCode == 39
          next_slide()
        if event.keyCode == 37
          prev_slide()

    themes.dialog_init()
    cloud.init(themes)
    img.init()
    scribe_setup()

  require ['domReady!'], ->
    activity.write = ()->
      obj =
        HTML: container.html()
        Theme: themes.get_theme()
      jsonData = JSON.stringify obj
      localStorage['slides'] = jsonData
      dictstore.save()

    window.addEventListener 'activityStop', () ->
      event.preventDefault()
      activity.write()
      activity.close()

    dictstore.init ->
        data = localStorage['slides']
        obj = JSON.parse data
        container.HTML obj.html

        themes.set_theme (obj.Theme || themes.get_default())
        img.setup_palettes()
        do_bar()
        scribe_setup()

    setInterval activity.write, 1000
