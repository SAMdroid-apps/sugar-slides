(function() {
  var MIN_TOUCH_DISTANCE;

  MIN_TOUCH_DISTANCE = 400;

  define(function(require) {
    var add_slide, container, next_slide, obj, prev_slide, remove_slide, scribe;
    scribe = require('activity/scribe');
    require('jquery');
    container = $('.slides');
    obj = {};
    obj.do_bar = function() {
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
      return obj.do_bar();
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
      return obj.do_bar();
    };
    add_slide = function() {
      var center, ele;
      ele = $("<section class='to-see'>               <h1>New Slide</h1>               <p>Lets type and make a new slide</p>             </section>");
      center = $('section:not(.to-see, .seen)', container);
      ele.insertAfter(center);
      scribe.setup_slide(ele);
      next_slide();
      return obj.do_bar();
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
    obj.init = function() {
      var touch_starts;
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
        return scribe.setup();
      });
      return $('body').keyup(function(event) {
        if (document.activeElement.nodeName === "BODY" || $('#main-toolbar').hasClass('hidden')) {
          if (event.keyCode === 39) {
            next_slide();
          }
          if (event.keyCode === 37) {
            return prev_slide();
          }
        }
      });
    };
    return obj;
  });

}).call(this);
