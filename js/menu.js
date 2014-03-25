(function() {
  define(function(require) {
    var set_context_menu_postion;
    return set_context_menu_postion = function(event, contextMenu) {
      var menuDimension, menuPostion, mousePosition;
      mousePosition = {};
      menuPostion = {};
      menuDimension = {};
      menuDimension.x = contextMenu.outerWidth();
      menuDimension.y = contextMenu.outerHeight();
      mousePosition.x = event.pageX;
      mousePosition.y = event.pageY;
      if (mousePosition.x + menuDimension.x > $(window).width() + $(window).scrollLeft()) {
        menuPostion.x = mousePosition.x - menuDimension.x;
      } else {
        menuPostion.x = mousePosition.x;
      }
      if (mousePosition.y + menuDimension.y > $(window).height() + $(window).scrollTop()) {
        menuPostion.y = mousePosition.y - menuDimension.y;
      } else {
        menuPostion.y = mousePosition.y;
      }
      return menuPostion;
    };
  });

}).call(this);
