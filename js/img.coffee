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
      target.css 'width', "#{ w }%"

    $('#smaller', popover).click ->
      w = target.attr 'width'
      w = w.trim()
      w = w.substring 0, w.search('%')

      w = Number w
      w -= 5
      if w <= 5
        w = 5
      target.attr 'width', "#{ w }%"
      target.css 'width', "#{ w }%"

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

  this.init = ->
    ele = $ 'button#img'
    ele.click ->
      $('input#img').click()

    ele = $ 'input#img'
    ele[0].addEventListener 'change', on_files_changed, false

    eles = $ 'img'
    eles.each (index) ->
      setup_img_ele $(this)

  this
