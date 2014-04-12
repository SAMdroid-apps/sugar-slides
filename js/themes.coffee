define (require) ->
  require 'jquery'

  T_DEFAULT =
    file: 'default'

  T_FLAT =
     file: 'flat'

  T_BLACK =
     file: 'black'

  T_HAND =
     file: 'handwritten'

  THEMES = [T_DEFAULT, T_FLAT, T_HAND, T_BLACK]

  current_theme = T_DEFAULT.file

  obj = {}

  obj.get_default = ->
    T_DEFAULT.file

  obj.set_theme = (name) ->
    $('link#theme').attr 'href', "css/themes/#{ name }.css"
    current_theme = name

    $('.slides').hide().show()  # Force Redraw

  obj.get_theme = ->
    current_theme

  obj.dialog_init = ->
    list = $ '.themes-list'
    for theme in THEMES
      ele = $ "<li>
        <img src='res/themes-picture/#{ theme.file }.png' />
               </li>"
      ele.data 'file', theme.file
      ele.click ->
        obj.set_theme $(this).data 'file'
        $('.theme-dialog').fadeOut()
      list.append ele

    $('button#close').click ->
      $('.theme-dialog').fadeOut()

    $('button#theme').click ->
      $('.theme-dialog').fadeIn()

  obj
