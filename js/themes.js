(function() {
  define(function(require) {
    var THEMES, T_DEFAULT, current_theme;
    require('jquery');
    T_DEFAULT = {
      file: 'default',
      description: 'DEFUALT theme'
    };
    THEMES = [T_DEFAULT];
    current_theme = T_DEFAULT.file;
    this.get_default = function() {
      return T_DEFAULT.file;
    };
    this.set_theme = function(name) {
      $('link#theme').attr('href', "css/theme-" + name + ".css");
      return current_theme = name;
    };
    this.get_theme = function() {
      return current_theme;
    };
    this.dialog_init = function() {
      var ele, list, theme, _i, _len;
      list = $('.themes-list');
      for (_i = 0, _len = THEMES.length; _i < _len; _i++) {
        theme = THEMES[_i];
        ele = $("<li>        <img src='res/theme-" + theme.file + ".png' />        " + theme.description + "               </li>");
        ele.data('file', theme.file);
        ele.click(function() {
          set_theme($(this).data('file'));
          return $('.theme-dialog').fadeOut();
        });
        list.append(ele);
      }
      $('button#close').click(function() {
        return $('.theme-dialog').fadeOut();
      });
      return $('button#theme').click(function() {
        return $('.theme-dialog').fadeIn();
      });
    };
    return this;
  });

}).call(this);
