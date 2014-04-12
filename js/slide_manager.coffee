MIN_TOUCH_DISTANCE = 400

define (require) ->
  scribe = require 'activity/scribe'
  require 'jquery'
  container = $ '.slides'

  obj = {}

  # Staticmethod
  obj.do_bar = ->
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

    obj.do_bar()

  prev_slide = ->
    slides = $ 'section.seen', container
    if slides.length == 0
      return

    center = $ 'section:not(.to-see, .seen)', container
    center.addClass 'to-see'

    slide = $ slides[slides.length - 1]
    slide.removeClass 'seen'

    obj.do_bar()

  add_slide = ->
    ele = $ "<section class='to-see'>
               <h1>New Slide</h1>
               <p>Lets type and make a new slide</p>
             </section>"
    center = $ 'section:not(.to-see, .seen)', container
    ele.insertAfter center
    scribe.setup_slide ele
    next_slide()

    obj.do_bar()

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

  # Staticmethod
  obj.init = ->
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
      scribe.setup()

    $('body').keyup (event) ->
      # Key shortcuts only if the user is not editing or fullscreen
      if document.activeElement.nodeName == "BODY" or
                               $('#main-toolbar').hasClass 'hidden'
        if event.keyCode == 39
          next_slide()
        if event.keyCode == 37
          prev_slide()

  obj
