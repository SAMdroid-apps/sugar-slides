(function() {
  define(function(require) {
    var POST_URL, cloud, themes;
    themes = null;
    cloud = {};
    POST_URL = 'http://slide-cloud.appspot.com/s/new';
    cloud.send_to_cloud = function() {
      var container, content, dialog, obj;
      container = $('.slides');
      obj = {
        HTML: container.html(),
        Theme: themes.get_theme()
      };
      dialog = $('.cloud-dialog');
      dialog.fadeIn();
      content = $('.content', dialog);
      content.html('Sending to the cloud...');
      return $.post(POST_URL, JSON.stringify(obj)).done(function(data) {
        data = JSON.parse(data);
        return content.html("Slides Shared! <br/>          Here is the link <i><code>" + data.ShortUrl + "</code></i><br/>          Please keep it safe - as sending the same thing makes the cloud sad :(        ");
      }).error(function() {
        return content.html('Error getting data, please check your internet');
      });
    };
    cloud.init = function(t) {
      var btn, close;
      themes = t;
      btn = $('button#cloud');
      btn.click(function() {
        return cloud.send_to_cloud();
      });
      close = $('.cloud-dialog #close');
      return close.click(function() {
        var dialog;
        dialog = $('.cloud-dialog');
        return dialog.fadeOut();
      });
    };
    return cloud;
  });

}).call(this);
