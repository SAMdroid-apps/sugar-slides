define (require) ->
  datastore = require 'sugar-web/datastore'
  set_context_menu_postion = require 'activity/menu'

  do_selection_menu = (event, target, fromClick) ->
    event = event || window.event
    popover = $ '.image-toolbar'

    pos = set_context_menu_postion event, popover
    popover.css 'top': pos.y
    popover.css 'left', pos.x
    popover.css 'opacity', '100'

    $('#delete', popover).click ->
      target.remove()

    $('#bigger', popover).click ->
      w = target.attr 'width'
      w = w.trim()
      w = w.substring 0, w.search('%')

      w = Number w
      w += 5
      if w >= 100
        w = 100
      target.attr 'width', "#{ w }%"

    $('#smaller', popover).click ->
      w = target.attr 'width'
      w = w.trim()
      w = w.substring 0, w.search('%')

      w = Number w
      w -= 5
      if w <= 5
        w = 5
      target.attr 'width', "#{ w }%"

    hide = ->
      popover.css 'opacity', '0'
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

        ele = $ "<img src='#{ event.target.result }'/
                      width='50%' class='slide-image'>"

        setup_img_ele ele

        h = $('h1, h2', slide)
        if h1.lenght != 0
          ele.insertAfter h.last()
          return

        slide.prepend ele
      reader.readAsDataURL f

  this.init = ->
    ele = $ '#img'
    ele[0].addEventListener 'change', on_files_changed, false

    eles = $ 'img'
    eles.each (index) ->
      setup_img_ele $(this)

  this
