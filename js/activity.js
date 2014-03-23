(function() {
  define(function(require) {
    var Scribe, activity, add_slide, container, d, dictstore, do_selection_menu, next_slide, prev_slide, remove_slide, scribePluginHeadingCommand, scribePluginToolbar, scribe_slide_setup, set_context_menu_postion, themes;
    activity = require('sugar-web/activity/activity');
    dictstore = require('sugar-web/dictstore');
    themes = require('activity/themes');
    require('jquery');
    Scribe = require('scribe');
    scribePluginToolbar = require('plugins/scribe-plugin-toolbar');
    scribePluginHeadingCommand = require('plugins/scribe-plugin-heading-command');
    container = $('.slides');
    activity.setup();
    activity.write = function() {
      var jsonData, obj;
      obj = {
        html: container.html(),
        theme: themes.get_theme()
      };
      jsonData = JSON.stringify(obj);
      localStorage['slides'] = jsonData;
      return dictstore.save();
    };
    window.addEventListener('activityStop', function() {
      event.preventDefault();
      activity.write();
      return activity.close();
    });
    scribe_slide_setup = function(ele) {
      var s;
      return;
      s = new Scribe(ele, {
        allowBlockElements: true
      });
      return s.use(scribePluginToolbar($('.scribe-toolbar')[0]));
    };
    next_slide = function() {
      var center, slide, slides;
      slides = $('section.to-see', container);
      if (slides.length === 0) {
        return;
      }
      center = $('section:not(.to-see, .seen)', container);
      center.addClass('seen');
      slide = $(slides[0]);
      return slide.removeClass('to-see');
    };
    prev_slide = function() {
      var center, slide, slides;
      slides = $('section.seen', container);
      if (slides.length === 0) {
        return;
      }
      center = $('section:not(.to-see, .seen)', container);
      center.addClass('to-see');
      slide = $(slides[slides.length - 1]);
      return slide.removeClass('seen');
    };
    add_slide = function() {
      var center, ele;
      ele = $("<section class='to-see'>               <h1>New Slide</h1>               <p>Lets type and make a new slide</p>             </section>");
      center = $('section:not(.to-see, .seen)', container);
      ele.insertAfter(center);
      next_slide();
      return scribe_slide_setup(ele[0]);
    };
    remove_slide = function() {
      var center, slides;
      center = $('section:not(.to-see, .seen)', container);
      center.remove();
      slides = $('section');
      if (slides.length === 0) {
        return container.html("<section>               <h1>New Slide</h1>               <p>Lets type and make a new slide</p>                      </section>");
      } else {
        slides = $('section.to-see', container);
        if (slides.length > 0) {
          return next_slide();
        } else {
          return prev_slide();
        }
      }
    };
    set_context_menu_postion = function(event, contextMenu) {
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
    do_selection_menu = function(event) {
      var popover, pos;
      if ((container.attr('contenteditable')) === 'true') {
        event = event || window.event;
        popover = $('.scribe-toolbar');
        pos = set_context_menu_postion(event, popover);
        popover.css({
          'top': pos.y
        });
        popover.css('left', pos.x);
        popover.css('opacity', '100');
        return $('body').one('click', function() {
          return popover.css('opacity', '0');
        });
      }
    };
    d = $('document');
    return d.ready(function() {
      var ele, s;
      ele = $('.slides');
      s = new Scribe(ele[0], {
        allowBlockElements: true
      });
      s.use(scribePluginHeadingCommand(1));
      s.use(scribePluginHeadingCommand(2));
      s.use(scribePluginToolbar(document.querySelector('.scribe-toolbar')));
      container.on('contextmenu', function(event) {
        event.preventDefault();
        return do_selection_menu();
      });
      $('button#format').click(function() {
        var popover, pos;
        popover = $('.scribe-toolbar');
        if (this.palette_is_up || false) {
          popover.css('opacity', '0');
          return this.palette_is_up = false;
        } else {
          pos = $(this).position();
          pos.top += $(this).outerWidth() - 2;
          pos.left -= 10;
          popover.css({
            'top': pos.top
          });
          popover.css('left', pos.left);
          popover.css('opacity', '1');
          return this.palette_is_up = true;
        }
      });
      $('button#n').click(function() {
        return next_slide();
      });
      $('button#p').click(function() {
        return prev_slide();
      });
      $('button#add').click(function() {
        return add_slide();
      });
      $('button#remove').click(function() {
        if (confirm('Delete the current slide?')) {
          return remove_slide();
        }
      });
      $('button#fullscreen').click(function() {
        $('#main-toolbar').addClass('hidden');
        $('button#unfullscreen').show();
        $(this).hide();
        return $('.slides').attr('contenteditable', 'false');
      });
      $('button#unfullscreen').click(function() {
        $('#main-toolbar').removeClass('hidden');
        $('button#fullscreen').show();
        $(this).hide();
        return $('.slides').attr('contenteditable', 'true');
      });
      $('body').keyup(function(event) {
        if (event.keyCode === 39) {
          next_slide();
        }
        if (event.keyCode === 37) {
          return prev_slide();
        }
      });
      themes.dialog_init();
      dictstore.init(function() {
        var data, obj;
        data = localStorage['slides'];
        obj = JSON.parse(data);
        container.html(obj.html);
        $('.slides').attr('contenteditable', 'true');
        return themes.set_theme(obj.theme || themes.get_default());
      });
      return setInterval(activity.write, 1000);
    });
  });

}).call(this);
