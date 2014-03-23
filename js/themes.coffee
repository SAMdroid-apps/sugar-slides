define (require) ->
  require 'jquery'

  T_DEFAULT =
    file: 'default'
    description: 'DEFUALT theme'

  #  T_SERIF =
  #    file: 'serif'
  #    description: 'Funky Theme'

  THEMES = [T_DEFAULT]

  current_theme = T_DEFAULT.file

  this.get_default = ->
    T_DEFAULT.file

  this.set_theme = (name) ->
    $('link#theme').attr 'href', "css/theme-#{ name }.css"
    current_theme = name

  this.get_theme = ->
    current_theme

  this.dialog_init = ->
    list = $ '.themes-list'
    for theme in THEMES
      ele = $ "<li>
        <img src='res/theme-#{ theme.file }.png' />
        #{ theme.description }
               </li>"
      ele.data 'file', theme.file
      ele.click ->
        set_theme $(this).data 'file'
        $('.theme-dialog').fadeOut()
      list.append ele

    $('button#close').click ->
      $('.theme-dialog').fadeOut()

    $('button#theme').click ->
      $('.theme-dialog').fadeIn()

  this
