(function() {
  define(function(require) {
    var Scribe, do_selection_menu, obj, scribePluginHeadingCommand, scribePluginToolbar, set_context_menu_postion;
    require('jquery');
    Scribe = require('scribe');
    scribePluginToolbar = require('plugins/scribe-plugin-toolbar');
    scribePluginHeadingCommand = require('plugins/scribe-plugin-heading-command');
    set_context_menu_postion = require('activity/menu');
    do_selection_menu = function(event) {
      var popover, pos;
      if (!$('#main-toolbar').hasClass('hidden')) {
        event = event || window.event;
        popover = $('.scribe-toolbar');
        pos = set_context_menu_postion(event, popover);
        popover.css({
          'top': pos.y
        });
        popover.css('left', pos.x);
        popover.fadeIn();
        return $('body').one('click', function() {
          return popover.fadeOut();
        });
      }
    };
    obj = {};
    obj.setup_slide = function(ele) {
      var s;
      s = new Scribe(ele[0], {
        allowBlockElements: true
      });
      s.use(scribePluginHeadingCommand(1));
      s.use(scribePluginHeadingCommand(2));
      s.use(scribePluginToolbar(document.querySelector('.scribe-toolbar')));
      return ele.attr('contenteditable', 'true');
    };
    obj.setup = function() {
      var eles;
      eles = $('section');
      return eles.each(function() {
        return obj.setup_slide($(this));
      });
    };
    obj.setup_once = function() {
      $('button#format').click(function() {
        var popover, pos;
        popover = $('.scribe-toolbar');
        if (this.palette_is_up || false) {
          popover.hide();
          return this.palette_is_up = false;
        } else {
          pos = $(this).position();
          pos.top += $(this).outerWidth() - 2;
          pos.left -= 10;
          popover.css({
            'top': pos.top
          });
          popover.css('left', pos.left);
          popover.show();
          return this.palette_is_up = true;
        }
      });
      return $('.slides').on('contextmenu', function(event) {
        if (event.toElement.tagName === 'IMG') {
          return;
        }
        event.preventDefault();
        return do_selection_menu();
      });
    };
    return obj;
  });

}).call(this);
