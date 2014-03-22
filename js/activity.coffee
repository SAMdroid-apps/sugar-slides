define (require) ->
  activity = require 'sugar-web/activity/activity'
  datastore = require 'sugar-web/datastore'

  require 'jquery'
  Scribe = require 'scribe'
  scribePluginToolbar = require 'plugins/scribe-plugin-toolbar'
  scribePluginHeadingCommand = require 'plugins/scribe-plugin-toolbar'
 
  container = $ '.slides'
 
  activity.setup()
  datastoreObject = activity.getDatastoreObject()
  onLoaded = (error, metadata, data) ->
    alert data
    obj = JSON.parse data
    console.log obj
    container.html obj.html
    $('section').each (x, ele) ->
      scribe_slide_setup ele
    undefined
  datastoreObject.loadAsText onLoaded

  activity.write = (callback)->
    obj =
      html: container.html()
    jsonData = JSON.stringify obj
    datastoreObject.setDataAsText jsonData
    datastoreObject.save()

  window.addEventListener 'activityStop', () ->
    event.preventDefault()
    activity.write()
    activity.close()

  scribe_slide_setup = (ele) ->
    return
    s = new Scribe ele, { allowBlockElements: true }
    s.use scribePluginToolbar($('.scribe-toolbar')[0])

  next_slide = ->
    slides = $ 'section.to-see', container
    if slides.length == 0
      return

    center = $ 'section:not(.to-see, .seen)', container
    center.addClass 'seen'

    slide = $ slides[0]
    slide.removeClass 'to-see'

  prev_slide = ->
    slides = $ 'section.seen', container
    if slides.length == 0
      return

    center = $ 'section:not(.to-see, .seen)', container
    center.addClass 'to-see'

    slide = $ slides[slides.length - 1]
    slide.removeClass 'seen'

  add_slide = ->
    ele = $ "<section class='to-see'>
               <h1>New Slide</h1>
               <p>Lets type and make a new slide</p>
             </section>"
    center = $ 'section:not(.to-see, .seen)', container
    ele.insertAfter center
    next_slide()
    scribe_slide_setup ele[0]


  d = $ 'document'
  d.ready ->
    ele = $ '.slides'
    s = new Scribe ele[0], { allowBlockElements: true }
    s.use scribePluginToolbar(document.querySelector '.scribe-toolbar')
    #  s.use scribePluginHeadingCommand(1)

    $('section').each (x, ele) ->
      scribe_slide_setup ele

    $('button#n').click ->
      next_slide()

    $('button#p').click ->
      prev_slide()

    $('button#add').click ->
      add_slide()

    $('body').keyup (event) ->
      if event.keyCode == 39
        next_slide()
      if event.keyCode == 37
        prev_slide()
