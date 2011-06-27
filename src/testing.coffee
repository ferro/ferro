window.log = (x) -> console.log x

contentPort = {}

port =
  onMessage:
    addListener: (fn) ->
      port.fn = fn
  postMessage: (msg) ->
    contentPort.fn msg

contentPort =
  onMessage:
    addListener: (fn) ->
      contentPort.fn = fn
  postMessage: (msg) ->
    port.fn msg

window.chrome =
  extension:
    connect: ->
      contentPort
    onConnect:
      addListener: (fn) ->
        fn port