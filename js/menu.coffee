define (require) ->
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
