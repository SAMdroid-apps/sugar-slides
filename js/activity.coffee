define (require) ->
  activity = require 'sugar-web/activity/activity'
  dictstore = require 'sugar-web/dictstore'

  require 'jquery'
  Scribe = require 'scribe'
  scribePluginToolbar = require 'plugins/scribe-plugin-toolbar'
  scribePluginHeadingCommand = require 'plugins/scribe-plugin-heading-command'
 
  container = $ '.slides'
 
  activity.setup()

  activity.write = ()->
    obj =
      html: container.html()
    jsonData = JSON.stringify obj
    localStorage['slides'] = jsonData
    dictstore.save()

  window.addEventListener 'activityStop', () ->
    event.preventDefault()
    activity.write()
    activity.close()

  scribe_slide_setup = (ele) ->
    return
    s = new Scribe ele, { allowBlockElements: true }
    s.use scribePluginToolbar($('.scribe-toolbar')[0])

  next_slide = ->
    slides = $ 'section.to-see', container
    if slides.length == 0
      return

    center = $ 'section:not(.to-see, .seen)', container
    center.addClass 'seen'

    slide = $ slides[0]
    slide.removeClass 'to-see'

  prev_slide = ->
    slides = $ 'section.seen', container
    if slides.length == 0
      return

    center = $ 'section:not(.to-see, .seen)', container
    center.addClass 'to-see'

    slide = $ slides[slides.length - 1]
    slide.removeClass 'seen'

  add_slide = ->
    ele = $ "<section class='to-see'>
               <h1>New Slide</h1>
               <p>Lets type and make a new slide</p>
             </section>"
    center = $ 'section:not(.to-see, .seen)', container
    ele.insertAfter center
    next_slide()
    scribe_slide_setup ele[0]

  remove_slide = ->
    center = $ 'section:not(.to-see, .seen)', container
    center.remove()

    slides = $ 'section'
    if slides.length == 0
      container.html "<section>
               <h1>New Slide</h1>
               <p>Lets type and make a new slide</p>
                      </section>"
    else
      slides = $ 'section.to-see', container
      if slides.length > 0
        next_slide()
      else
        prev_slide()

  set_context_menu_postion = (event, contextMenu) ->
    #  Thanks 'linley' 
    #  http://stackoverflow.com/questions/5470032/positioning-of-context-menu
    mousePosition = {}
    menuPostion = {}
    menuDimension = {}

    menuDimension.x = contextMenu.outerWidth()
    menuDimension.y = contextMenu.outerHeight()
    mousePosition.x = event.pageX
    mousePosition.y = event.pageY

    if mousePosition.x + menuDimension.x > $(window).width() + $(window).scrollLeft()
      menuPostion.x = mousePosition.x - menuDimension.x
    else
      menuPostion.x = mousePosition.x

    if mousePosition.y + menuDimension.y > $(window).height() + $(window).scrollTop()
      menuPostion.y = mousePosition.y - menuDimension.y
    else
      menuPostion.y = mousePosition.y

    menuPostion

  do_selection_menu = (event) ->
    if (container.attr 'contenteditable') == 'true'
      event = event || window.event
      popover = $ '.scribe-toolbar'

      pos = set_context_menu_postion event, popover
      popover.css 'top': pos.y
      popover.css 'left', pos.x
      popover.css 'opacity', '100'

      $('body').one 'click', ->
        popover.css 'opacity', '0'


  d = $ 'document'
  d.ready ->
    ele = $ '.slides'
    s = new Scribe ele[0], { allowBlockElements: true }
    s.use scribePluginHeadingCommand(1)
    s.use scribePluginHeadingCommand(2)
    s.use scribePluginToolbar(document.querySelector '.scribe-toolbar')


    container.on 'contextmenu', (event) ->
      event.preventDefault()
      do_selection_menu()
    

    $('section').each (x, ele) ->
      scribe_slide_setup ele

    $('button#n').click ->
      next_slide()

    $('button#p').click ->
      prev_slide()

    $('button#add').click ->
      add_slide()

    $('button#remove').click ->
      if confirm 'Delete the current slide?'
        remove_slide()

    $('button#fullscreen').click ->
      $('#main-toolbar').addClass 'hidden'
      $('button#unfullscreen').show()
      $(this).hide()
      $('.slides').attr 'contenteditable', 'false'

    $('button#unfullscreen').click ->
      $('#main-toolbar').removeClass 'hidden'
      $('button#fullscreen').show()
      $(this).hide()
      $('.slides').attr 'contenteditable', 'true'

    $('body').keyup (event) ->
      if event.keyCode == 39
        next_slide()
      if event.keyCode == 37
        prev_slide()

   dictstore.init ->
     data = localStorage['slides']
     obj = JSON.parse data
     container.html obj.html
     $('.slides').attr 'contenteditable', 'true'

    setInterval activity.write, 1000
