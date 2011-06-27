port = chrome.extension.connect()

window.onkeydown = (e) ->
  port.postMessage e

port.onMessage.addListener (msg) ->
  log 'b' + msg.toString()