define (require) ->
  themes = null
  cloud = {}

  POST_URL = 'http://slide-cloud.appspot.com/s/new'

  cloud.send_to_cloud = ->
    container = $ '.slides'
    obj =
      HTML: container.html()
      Theme: themes.get_theme()

    dialog = $ '.cloud-dialog'
    dialog.fadeIn()

    content = $ '.content', dialog
    content.html 'Sending to the cloud...'

    $.post(POST_URL, JSON.stringify obj)
      .done (data) ->
        data = JSON.parse data
        content.html "Slides Shared! <br/>
          Here is the link <i><code>#{ data.ShortUrl }</code></i><br/>
          Please keep it safe - as sending the same thing makes the cloud sad :(
        "
      .error ->
        content.html 'Error getting data, please check your internet'

  cloud.init = (t) ->
    themes = t

    btn = $ 'button#cloud'
    btn.click ->
      cloud.send_to_cloud()

    close = $ '.cloud-dialog #close'
    close.click ->
      dialog = $ '.cloud-dialog'
      dialog.fadeOut()

  cloud
