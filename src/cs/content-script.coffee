STATES =
  INACTIVE: 0
  MAIN_SELECT: 1
  TEXT: 2
  COMMAND: 3

PERIOD = 46
TAB = 9
BACKSPACE = 8
N = 78
P = 80
J = 74
K = 75

state = STATES.INACTIVE
entered = ''
context = null
is_text = false

main-choices = []
main = null
cmd-choices = []
cmd = null

refresh_shortcut = ->
  chrome.extension.sendRequest 'shortcut', (value) ->
    shortcut = value

refresh_shortcut()

refresh_sessions = ->
  chrome.extension.sendRequest 'sessions', (value) ->
    sessions = value
#push

css = document.createElement 'link'
css.href = chrome.extension.getURL 'content-script.css'
css.media = 'all'
css.rel = 'stylesheet'
css.type = 'text/css'
document.getElementsByTagName('head')[0].appendChild css

window.onkeydown = (e) ->
  if state != STATES.INACTIVE
    if e.keyCode is f.KEYS.RETURN and cmd
      execute
    else if e.keyCode is f.KEYS.ESC or shortcut_matches e
      close

  switch state
    when STATES.INACTIVE
      if shortcut_matches e
        show 'f-box'
        state = STATES.MAIN_SELECT
    when STATES.MAIN_SELECT
      if e.keyCode is PERIOD
        show 'f-text'
        document.getElementById('f-text').focus()
        context = f.CONTEXTS.TEXT
        state = STATES.TEXT
        is_text = true
      else if e.keyCode is TAB
        switch_to_command()
      else if e.keyCode is BACKSPACE
        entered = ''
        refresh_entered()
      else if is_down e
        main = (main + 1) % 5
      else if is_up e
        main = (main - 1) % 5
      else
        update e
    when STATES.TEXT
      if e.keyCode is TAB
        entered = document.getElementById('f-text').value
        switch_to_command()
    when STATES.COMMAND
      if e.keyCode is TAB
        state = is_text ? STATES.TEXT : STATES.MAIN_SELECT
      else if is_down e
        cmd = (cmd + 1) % 5
      else if is_up e
        cmd = (cmd - 1) % 5
      else
        update e

  # log 'down ' + String.fromCharCode e.keyCode
  # if _(f.keys.codes).chain().values().include(e.keyCode).value()
  #   log 'h'

  document.querySelector 'div.blah'

# main has cmds, apps, extensions, sessions, and tabs
update = (e) ->
  c = String.fromCharCode e.keyCode
  return unless c

  entered += c
  refresh_entered()
  if state = STATES.MAIN_SELECT
  #update context
  f.COMMAND_NAMES[f.CONTEXTS.NONE]
  else if state = STATES.COMMAND
    choices = f.COMMAND_NAMES[context]

  choices = _.sortBy choices, (choice) ->
    choice.name.score entered

  #display

is_down = (e) ->
  k = e.keyCode
  k is f.KEYS.CODES.PAGE_DOWN or
    k is f.KEYS.CODES.DOWN or
    ((e.altKey or e.ctrlKey) and (k is N or k is J))

is_up = (e) ->
  k = e.keyCode
  k is f.KEYS.CODES.PAGE_UP or
    k is f.KEYS.CODES.UP or
    ((e.altKey or e.ctrlKey) and (k is P or k is K))

refresh_entered = ->
  if state = STATES.MAIN_SELECT
    entered_id = 'f-entered-main'
  else
    entered_id = 'f-entered-cmd'
  document.getElementById(entered_id).innerHtml = entered

shortcut_matches = (e) ->
  e.keyCode is shortcut.key and
    e.altKey is shortcut.altKey and
    e.ctrlKey is shortcut.ctrlKey and
    e.shiftKey is shiftKey.shiftKey

execute = ->
  unless cmd
    close
    return  #todo wrong

close = ->
  state = STATES.INACTIVE
  entered = ''
  context = null
  choices = []
  document.getElementById('f-box').style.visibility = 'hidden'
  is_text = false

show = (id) ->
  document.getElementById(id).style.visibility = 'visible'

switch_to_command = ->
  state = STATES.COMMAND
  choices = []
  #todo UI
