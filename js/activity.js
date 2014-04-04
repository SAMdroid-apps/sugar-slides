(function() {
  var MIN_TOUCH_DISTANCE;

  MIN_TOUCH_DISTANCE = 400;

  define(function(require) {
    var Scribe, activity, add_slide, cloud, container, d, dictstore, do_bar, do_selection_menu, img, next_slide, prev_slide, remove_slide, scribePluginHeadingCommand, scribePluginToolbar, scribe_setup, scribe_setup_slide, set_context_menu_postion, themes;
    activity = require('sugar-web/activity/activity');
    dictstore = require('sugar-web/dictstore');
    set_context_menu_postion = require('activity/menu');
    themes = require('activity/themes');
    img = require('activity/img');
    cloud = require('activity/cloud');
    require('jquery');
    Scribe = require('scribe');
    scribePluginToolbar = require('plugins/scribe-plugin-toolbar');
    scribePluginHeadingCommand = require('plugins/scribe-plugin-heading-command');
    container = $('.slides');
    activity.setup();
    do_bar = function() {
      var bar, x;
      bar = $('.bar');
      x = ($('section.seen').length) / ($('section').length - 1);
      return bar.css('width', "" + (x * 100) + "%");
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
      slide.removeClass('to-see');
      return do_bar();
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
      slide.removeClass('seen');
      return do_bar();
    };
    add_slide = function() {
      var center, ele;
      ele = $("<section class='to-see'>               <h1>New Slide</h1>               <p>Lets type and make a new slide</p>             </section>");
      center = $('section:not(.to-see, .seen)', container);
      ele.insertAfter(center);
      scribe_setup_slide(ele);
      next_slide();
      return do_bar();
    };
    remove_slide = function() {
      var center, slides;
      center = $('section:not(.to-see, .seen)', container);
      center.remove();
      slides = $('section');
      if (slides.length === 0) {
        container.html("<section>               <h1>New Slide</h1>               <p>Lets type and make a new slide</p>                      </section>");
        return scribe_setup_slide($('section', container));
      } else {
        slides = $('section.to-see', container);
        if (slides.length > 0) {
          return next_slide();
        } else {
          return prev_slide();
        }
      }
    };
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
    scribe_setup_slide = function(ele) {
      var s;
      s = new Scribe(ele[0], {
        allowBlockElements: true
      });
      s.use(scribePluginHeadingCommand(1));
      s.use(scribePluginHeadingCommand(2));
      s.use(scribePluginToolbar(document.querySelector('.scribe-toolbar')));
      return ele.attr('contenteditable', 'true');
    };
    scribe_setup = function() {
      var eles;
      eles = $('section');
      return eles.each(function() {
        return scribe_setup_slide($(this));
      });
    };
    d = $('document');
    d.ready(function() {
      var touch_starts;
      container.on('contextmenu', function(event) {
        if (event.toElement.tagName === 'IMG') {
          return;
        }
        event.preventDefault();
        return do_selection_menu();
      });
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
      $('button#n').click(function() {
        return next_slide();
      });
      $('button#p').click(function() {
        return prev_slide();
      });
      touch_starts = {};
      container[0].addEventListener('touchstart', function(event) {
        var t;
        t = event.touches[event.which];
        return touch_starts[event.which] = {
          x: t.clientX,
          y: t.clientY,
          can_do: true
        };
      });
      container[0].addEventListener('touchmove', function(event) {
        var distance, s, t;
        event.preventDefault();
        t = event.touches[event.which];
        s = touch_starts[event.which];
        distance = Math.abs(t.clientX - s.x) + Math.abs(t.clientY - s.y);
        if (distance > MIN_TOUCH_DISTANCE && s.can_do === true) {
          s.can_do = false;
          if ((t.clientX - s.x) > 0) {
            return prev_slide();
          } else {
            return next_slide();
          }
        }
      });
      container[0].addEventListener('touchend', function(event) {
        return touch_starts[event.which] = {};
      });
      $('button#add').click(function() {
        return add_slide();
      });
      $('button#img').click(function() {
        return activity.showObjectChooser(img.callback);
      });
      $('button#remove').click(function() {
        if (confirm('Delete the current slide?')) {
          return remove_slide();
        }
      });
      $('button#fullscreen').click(function() {
        var eles;
        $('#main-toolbar').addClass('hidden');
        $('button#unfullscreen').show();
        $(this).hide();
        eles = $('section');
        return eles.each(function() {
          return $(this).attr('contenteditable', 'false');
        });
      });
      $('button#unfullscreen').click(function() {
        $('#main-toolbar').removeClass('hidden');
        $('button#fullscreen').show();
        $(this).hide();
        return scribe_setup();
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
      cloud.init(themes);
      img.init();
      return scribe_setup();
    });
    return require(['domReady!'], function() {
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
      dictstore.init(function() {
        var data, obj;
        data = localStorage['slides'];
        obj = JSON.parse(data);
        container.html(obj.html);
        themes.set_theme(obj.theme || themes.get_default());
        img.setup_palettes();
        do_bar();
        return scribe_setup();
      });
      return setInterval(activity.write, 1000);
    });
  });

}).call(this);
