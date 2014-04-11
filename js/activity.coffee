define (require) ->
  activity = require 'sugar-web/activity/activity'
  dictstore = require 'sugar-web/dictstore'

  themes = require 'activity/themes'
  img = require 'activity/img'
  cloud = require 'activity/cloud'
  slides_manager = require 'activity/slide_manager'
  scribe = require 'activity/scribe'
 
  container = $ '.slides'


  require ['domReady!'], ->
    activity.setup()

    activity.write = ()->
      obj =
        HTML: container.html()
        Theme: themes.get_theme()
      jsonData = JSON.stringify obj
      localStorage['slides'] = jsonData
      dictstore.save()

    window.addEventListener 'activityStop', () ->
      event.preventDefault()
      activity.write()
      activity.close()

    dictstore.init ->
      data = localStorage['slides']
      obj = JSON.parse data
      container.html obj.HTML

      themes.set_theme (obj.Theme || themes.get_default())
      img.setup_palettes()
      slides_manager.do_bar()
      scribe.setup()

    themes.dialog_init()
    cloud.init(themes)
    img.init()
    scribe.setup_once()

    setInterval activity.write, 1000
