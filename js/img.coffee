define (require) ->
  datastore = require 'sugar-web/datastore'
  set_context_menu_postion = require 'activity/menu'

  do_selection_menu = (event, target, fromClick) ->
    event = event || window.event
    popover = $ '.image-toolbar'

    pos = set_context_menu_postion event, popover
    popover.css 'top': pos.y
    popover.css 'left', pos.x
    popover.fadeIn()

    $('#delete', popover).one 'click', ->
      target.remove()

    $('#bigger', popover).one 'click', ->
      s = target.attr 'width'
      s = s.trim()
      console.log s
      s = s.substring 0, s.search('%')
      console.log s

      w = Number s
      w += 8
      if w >= 100
        w = 100
      target.attr 'width', "#{ String w }%"
      target.css 'width', "#{ String w }%"

    $('#smaller', popover).one 'click', ->
      s = target.attr 'width'
      s = s.trim()
      console.log s
      s = s.substring 0, s.search('%')
      console.log s

      w = Number s
      w -= 8
      if w <= 5
        w = 5
      target.attr 'width', "#{ String w }%"
      target.css 'width', "#{ String w }%"

    hide = ->
      popover.fadeOut()
      $('button', popover).off 'click'
    $('body').one 'click', ->
      if fromClick
        $('body').one 'click', hide
      else
        hide()

  setup_img_ele = (ele) ->
    ele.on 'contextmenu', (event) ->
      event.preventDefault()
      do_selection_menu(event, ele)

    ele.on 'click', (event) ->
      event.preventDefault()
      do_selection_menu(event, ele, true)

    ele.on 'dragstart', (event) ->
      event.preventDefault()

  on_files_changed = (event) ->
    files = this.files || event.target.files
    for f in files
      if not f.type.match 'image.*'
        continue

      reader = new FileReader()
      reader.onload = (event) ->
        slide = $ 'section:not(.to-see, .seen)'

        ele = $ "<div class='img-container' width='50%'></div>"
        ele.css 'width', '50%'
        setup_img_ele ele

        img = $ "<img src='#{ event.target.result }'/
                      class='slide-image' />"
        img.css 'width', '100%'
        ele.append img

        caption = $ "<div class='caption'>Image Caption</div>"
        ele.append caption

        h = $('h1, h2', slide)
        if h1.lenght != 0
          ele.insertAfter h.first()
        else
          slide.prepend ele
        
      reader.readAsDataURL f

  obj = {}

  obj.init = ->
    ele = $ 'button#img'
    ele.click ->
      $('input#img').click()

    ele = $ 'input#img'
    ele[0].addEventListener 'change', on_files_changed, false

  obj.setup_palettes = ->
    eles = $ '.img-container'
    eles.each ->
      setup_img_ele $(this)

  obj
