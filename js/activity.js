(function() {
  define(function(require) {
    var activity, cloud, container, dictstore, img, scribe, slides_manager, themes;
    activity = require('sugar-web/activity/activity');
    dictstore = require('sugar-web/dictstore');
    themes = require('activity/themes');
    img = require('activity/img');
    cloud = require('activity/cloud');
    slides_manager = require('activity/slide_manager');
    scribe = require('activity/scribe');
    container = $('.slides');
    return require(['domReady!'], function() {
      activity.setup();
      activity.write = function() {
        var jsonData, obj;
        obj = {
          HTML: container.html(),
          Theme: themes.get_theme()
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
        try {
          container.html(obj.HTML);
        } catch (_error) {
          return;
        }
        themes.set_theme(obj.Theme || themes.get_default());
        img.setup_palettes();
        slides_manager.do_bar();
        return scribe.setup();
      });
      themes.dialog_init();
      cloud.init(themes);
      img.init();
      scribe.setup_once();
      return setInterval(activity.write, 1000);
    });
  });

}).call(this);
