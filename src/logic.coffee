chrome.extension.onConnect.addListener (port) ->
  port.onMessage.addListener (msg) ->
    port.postMessage 'x'




  # log 'down ' + String.fromCharCode e.keyCode
  # if _(f.keys.codes).chain().values().include(e.keyCode).value()
  #   log 'h'
