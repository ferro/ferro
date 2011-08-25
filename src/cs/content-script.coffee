STATES =
  INACTIVE: 0
  MAIN: 1
  TEXT: 2
  CMD: 3
choices:
  1: [] #main
  3: [] #cmd

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
selection = null
main = null
cmd = null
main_choice = null

# todo race conditions
refresh_all = ->
  chrome.management.getAll (_apps) ->
    apps = _apps
  chrome.windows.getAll {populate: true}, (wins) ->
    tabs = tab for tab in _.flatten(win.tabs for win in wins) when regex.test tab.url
    choices[STATES.MAIN] = f.CMD_NAMES[f.CONTEXTS.CMD]
      .concat tabs
      .concat apps
      .concat f.sessions

css = document.createElement 'link'
css.href = chrome.extension.getURL 'content-script.css'
css.media = 'all'
css.rel = 'stylesheet'
css.type = 'text/css'
document.getElementsByTagName('head')[0].appendChild css

window.onkeydown = (e) ->
  if state != STATES.INACTIVE
    if e.keyCode is f.KEYS.RETURN and selection
      execute
    else if e.keyCode is f.KEYS.ESC or shortcut_matches e
      close()

  switch state
    when STATES.INACTIVE
      if shortcut_matches e
        refresh_all
        show 'f-box'
        state = STATES.MAIN
    when STATES.MAIN
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
    when STATES.CMD
      if e.keyCode is TAB
        state = if is_text then STATES.TEXT else STATES.MAIN
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

  choices[state] = _.sortBy choices, (choice) ->
    # everything has a name except for tabs
    if choice.name
      choice.name.score entered
    else
      _.max [choice.title.score entered, choice.url.score entered]

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
  if state = STATES.MAIN
    entered_id = 'f-entered-main'
  else
    entered_id = 'f-entered-cmd'
  document.getElementById(entered_id).innerHtml = entered

shortcut_matches = (e) ->
  e.keyCode is f.shortcut.key and
    e.altKey is f.shortcut.altKey and
    e.ctrlKey is f.shortcut.ctrlKey and
    e.shiftKey is f.shortcut.shiftKey

execute = ->
  unless cmd
    close
    return



close = ->
  state = STATES.INACTIVE
  entered = ''
  context = null
  choices[STATES.MAIN] = []
  choices[STATES.CMD] = []
  document.getElementById('f-box').style.visibility = 'hidden'
  is_text = false

show = (id) ->
  document.getElementById(id).style.visibility = 'visible'

switch_to_command = ->
  state = STATES.CMD
  if is_text
    context = f.CONTEXTS.TEXT
  else
    main_choice = choices[STATES.MAIN][selection]
    selection = 0
    if main_choice.cmd
      chrome.tabs.getCurrent (tab) =>
        main_choice.cmd.fn tab
      close()
      return

    if main_choice.version
      context = if main_choice.isApp then f.CONTEXTS.APP else f.CONTEXTS.EXTENSION
    else if main_choice.index
      context = f.CONTEXTS.TAB
    else
      context = f.CONTEXTS.SESSION

  choices[STATES.CMD] = f.COMMAND_NAMES[context]
  #todo UI
