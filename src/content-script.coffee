STATES =
  INACTIVE: 0
  MAIN_SELECT: 1
  TEXT: 2
  COMMAND: 3



state = STATES.INACTIVE

window.onkeydown = (e) ->
  switch state
    when STATES.INACTIVE
      #browser isKeyPressed ?



  # log 'down ' + String.fromCharCode e.keyCode
  # if _(f.keys.codes).chain().values().include(e.keyCode).value()
  #   log 'h'
