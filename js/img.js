(function() {
  define(function(require) {
    var datastore, do_selection_menu, on_files_changed, set_context_menu_postion, setup_img_ele;
    datastore = require('sugar-web/datastore');
    set_context_menu_postion = require('activity/menu');
    do_selection_menu = function(event, target, fromClick) {
      var hide, popover, pos;
      event = event || window.event;
      popover = $('.image-toolbar');
      pos = set_context_menu_postion(event, popover);
      popover.css({
        'top': pos.y
      });
      popover.css('left', pos.x);
      popover.css('opacity', '100');
      $('#delete', popover).click(function() {
        return target.remove();
      });
      $('#bigger', popover).click(function() {
        var w;
        w = target.attr('width');
        w = w.trim();
        w = w.substring(0, w.search('%'));
        w = Number(w);
        w += 5;
        if (w >= 100) {
          w = 100;
        }
        target.attr('width', "" + w + "%");
        return target.css('width', "" + w + "%");
      });
      $('#smaller', popover).click(function() {
        var w;
        w = target.attr('width');
        w = w.trim();
        w = w.substring(0, w.search('%'));
        w = Number(w);
        w -= 5;
        if (w <= 5) {
          w = 5;
        }
        target.attr('width', "" + w + "%");
        return target.css('width', "" + w + "%");
      });
      hide = function() {
        return popover.css('opacity', '0');
      };
      return $('body').one('click', function() {
        if (fromClick) {
          return $('body').one('click', hide);
        } else {
          return hide();
        }
      });
    };
    setup_img_ele = function(ele) {
      ele.on('contextmenu', function(event) {
        event.preventDefault();
        return do_selection_menu(event, ele);
      });
      ele.on('click', function(event) {
        event.preventDefault();
        return do_selection_menu(event, ele, true);
      });
      return ele.on('dragstart', function(event) {
        return event.preventDefault();
      });
    };
    on_files_changed = function(event) {
      var f, files, reader, _i, _len, _results;
      files = this.files || event.target.files;
      _results = [];
      for (_i = 0, _len = files.length; _i < _len; _i++) {
        f = files[_i];
        if (!f.type.match('image.*')) {
          continue;
        }
        reader = new FileReader();
        reader.onload = function(event) {
          var caption, ele, h, img, slide;
          slide = $('section:not(.to-see, .seen)');
          ele = $("<div class='img-container' width='50%'></div>");
          ele.css('width', '50%');
          setup_img_ele(ele);
          img = $("<img src='" + event.target.result + "'/                      class='slide-image' />");
          img.css('width', '100%');
          ele.append(img);
          caption = $("<div class='caption'>Image Caption</div>");
          ele.append(caption);
          h = $('h1, h2', slide);
          if (h1.lenght !== 0) {
            return ele.insertAfter(h.first());
          } else {
            return slide.prepend(ele);
          }
        };
        _results.push(reader.readAsDataURL(f));
      }
      return _results;
    };
    this.init = function() {
      var ele, eles;
      ele = $('button#img');
      ele.click(function() {
        return $('input#img').click();
      });
      ele = $('input#img');
      ele[0].addEventListener('change', on_files_changed, false);
      eles = $('img');
      return eles.each(function(index) {
        return setup_img_ele($(this));
      });
    };
    return this;
  });

}).call(this);