STATES =
  INACTIVE: 0
  MAIN: 1
  TEXT: 2
  CMD: 3

choices =
  1: #main
    list: []
    selection: 0
  3: #cmd
    list: []
    selection: 0

NUM_CHOICES = 5

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
text = null

# todo race conditions
refresh_all = ->
  chrome.management.getAll (_apps) ->
    apps = _apps
  chrome.windows.getAll {populate: true}, (wins) ->
    tabs = tab for tab in _.flatten(win.tabs for win in wins) when regex.test tab.url
    choices[STATES.MAIN].list = f.CMD_NAMES[f.CONTEXTS.MAIN]
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
      execute()
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
        document.getElementById('f-text').style.visibility = 'visible'
        document.getElementById('f-text').focus()
        state = STATES.TEXT
      else if e.keyCode is TAB
        switch_to_command()
      else if e.keyCode is BACKSPACE
        set_entered ''
      else if is_down e or is_up e
        update_selection is_down e, STATES.MAIN
      else
        update e
    when STATES.TEXT
      if e.keyCode is TAB
        text = document.getElementById('f-text').value
        switch_to_command()
    when STATES.CMD
      if e.keyCode is TAB
        switch_from_command()
      else if is_down e or is_up e
        update_selection is_down e, STATES.CMD
      else
        update e
  # log 'down ' + String.fromCharCode e.keyCode
  # if _(f.keys.codes).chain().values().include(e.keyCode).value()
  #   log 'h'

  document.querySelector 'div.blah'

update_selection = (down, state) ->
  cur = choices[state].selection
  document.getElementById('f-' + cur).className = 'f-suggest';
  if down
    cur = (cur + 1) % NUM_CHOICES
  else
    cur = (cur - 1) % NUM_CHOICES
  document.getElementById('f-' + cur).className += ' f-selected';
  choices[state].selection = cur
  

# main has cmds, apps, extensions, sessions, and tabs
update = (e) ->
  c = String.fromCharCode e.keyCode
  return unless c # don't do anything with unprintable chars

  set_entered entered + c

  choices[state].list = _.sortBy choices[state].list, (choice) ->
    # everything has a name except for tabs
    if choice.name
      choice.name.score entered
    else
      _.max [choice.title.score entered, choice.url.score entered]

  #40 chr
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

set_entered = (e) ->
  entered = e
  document.getElementById('f-entered-text').innerHtml = e

shortcut_matches = (e) ->
  e.keyCode is f.shortcut.key and
    e.altKey is f.shortcut.altKey and
    e.ctrlKey is f.shortcut.ctrlKey and
    e.shiftKey is f.shortcut.shiftKey

execute = ->
  main_i = choices[STATES.MAIN].selection
  main_choice ?= choices[STATES.MAIN].list[main_i]
  if main_choice.cmd
    chrome.tabs.getCurrent (tab) =>
      main_choice.cmd.fn tab
  else
    cmd_i = choices[STATES.CMD].selection
    cmd_choice = choices[STATES.CMD].list[cmd_i]
    arg = text or main_choice
    cmd_choice.cmd.fn arg
  close()

close = ->
  state = STATES.INACTIVE
  set_entered ''
  context = null
  text = null
  document.getElementById('f-box').style.visibility = 'hidden'
  document.getElementById('f-main').className = 'f-selected'  #todo for text
  document.getElementById('f-cmd').className = ''
  document.getElementById('f-text').style.visibility = 'hidden'

show = (id) ->
  document.getElementById(id).style.visibility = 'visible'

switch_to_command = ->
  if text
    context = f.CONTEXTS.TEXT
  else
    main_i = choices[STATES.MAIN].selection
    main_choice = choices[STATES.MAIN].list[main_i]
    return if main_choice.cmd

    if main_choice.version
      context = if main_choice.isApp then f.CONTEXTS.APP else f.CONTEXTS.EXTENSION
    else if main_choice.index
      context = f.CONTEXTS.TAB
    else
      context = f.CONTEXTS.SESSION
  choices[STATES.CMD].list = f.COMMAND_NAMES[context]
  state = STATES.CMD

  set_entered ''

  document.getElementById('f-suggestions').style.opacity = 0
  document.getElementById('f-main').className = ''  #todo for text
  document.getElementById('f-cmd').className = 'f-selected'
  

switch_from_command = ->
  state = if text then STATES.TEXT else STATES.MAIN
  set_entered ''

  document.getElementById('f-suggestions').style.opacity = 0
  document.getElementById('f-main').className = 'f-selected'  #todo for text
  document.getElementById('f-cmd').className = ''
  
  