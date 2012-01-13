d 'injected'

ferro.STATES =
  INACTIVE: 0
  MAIN: 1
  TEXT: 2
  CMD: 3

suggestions =
  1: #main
    list: []
    selection: 0
  3: #cmd
    list: []
    selection: 0

ferro.NUM_SUGGESTIONS = 5

PERIOD = 46
TAB = 9
BACKSPACE = 8
N = 78
P = 80
J = 74
K = 75

state = ferro.STATES.INACTIVE
entered = ''
context = null
text = null
timer_id = null
suggestions_are_visible = false
apps = []
bookmarks = []

# css = document.createElement 'link'
# css.href = chrome.extension.getURL 'css/content-script.css'
# css.media = 'all'
# css.rel = 'stylesheet'
# css.type = 'text/css'
# document.getElementsByTagName('head')[0].appendChild css

chrome.extension.onRequest.addListener (request, sender, sendResponse) ->
  d 'setting:'
  d request
  _.extend ferro, request
        
chrome.extension.sendRequest action: 'get_state'
    
$ = (id) ->
  document.getElementById id

window.onkeydown = (e) =>
  d 'templates:', templates
  if state != ferro.STATES.INACTIVE
    if e.keyCode is ferro.KEYS.RETURN and selection
      execute()
    else if e.keyCode is ferro.KEYS.ESC or shortcut_matches e
      close()

  switch state
    when ferro.STATES.INACTIVE
      if shortcut_matches e
        refresh_all()
        $('f-box').style.opacity = 1
        state = ferro.STATES.MAIN
    when ferro.STATES.MAIN
      if e.keyCode is PERIOD
        $('f-text').style.visibility = 'visible'
        $('f-text').focus()
        state = ferro.STATES.TEXT
      else if e.keyCode is TAB
        switch_to_command()
      else if e.keyCode is BACKSPACE
        set_entered ''
      else if is_down e or is_up e
        update_selection is_down e, ferro.STATES.MAIN
      else
        update e
    when ferro.STATES.TEXT
      if e.keyCode is TAB
        text = $('f-text').value
        switch_to_command()
    when ferro.STATES.CMD
      if e.keyCode is TAB
        switch_from_command()
      else if is_down e or is_up e
        update_selection is_down e, ferro.STATES.CMD
      else
        update e
  # log 'down ' + String.fromCharCode e.keyCode
  # if _(ferro.keys.codes).chain().values().include(e.keyCode).value()
  #   log 'h'

  document.querySelector 'div.blah'

# todo race conditions
refresh_all = ->
  chrome.management.getAll (_apps) ->
    apps = _apps
  chrome.bookmarks.getTree (tree) ->
    flatten_bookmarks tree  
  chrome.windows.getAll {populate: true}, (wins) =>
    tabs = tab for tab in _.flatten(win.tabs for win in wins) when regex.test tab.url
    suggestions[ferro.STATES.MAIN].list = ferro.CMD_NAMES[ferro.CONTEXTS.MAIN]
      .concat tabs
      .concat apps
      .concat ferro.sessions
      .concat bookmarks
      .concat ferro.SPECIAL_PAGES

flatten_bookmarks = (node) ->
  if node.children and node.children.length isnt 0
    flatten_bookmarks child for child in node.children
  bookmarks.push node

update_selection = (down, state) ->
  unless suggestions_are_visible
    display_suggestions()
  cur = suggestions[state].selection
  $('f-' + cur).className = 'f-suggest';
  if down
    cur = (cur + 1) % NUM_SUGGESTIONS
  else
    cur = (cur - 1) % NUM_SUGGESTIONS
  $('f-' + cur).className += ' f-selected';
  suggestions[state].selection = cur
  
update = (e) ->
  c = String.fromCharCode e.keyCode
  return unless c and not (e.altKey or e.ctrlKey or e.shiftKey) # don't do anything with unprintable chars

  unless suggestions_are_visible
    if timer_id # very minor race condition
      clearTimeout timer_id
    timer_id = setTimeout "ferro.show_suggestions()", 1000
  set_entered entered + c
  re_sort()

ferro.show_suggestions = =>
  suggestions_are_visible = true # done early to diminish race
  display_suggestions()
  
display_suggestions = ->
  felem = $ '#ferro'
  body = $ 'body'
  body.removeChild felem if felem
  body.append templates.ferro {suggestions, state, entered}
  set_suggestions_visibility true

re_sort = ->
  suggestions[state].list = _.sortBy suggestions[state].list, (choice) =>
    # everything has a name except for tabs
    if choice.name
      choice.name.score entered
    else
      _.max [choice.title.score entered, choice.url.score entered]

  if suggestions_are_visible
    display_suggestions

set_suggestions_visibility = (visible) ->
  $('f-suggestions').style.opacity = if visible then 1 else 0
  suggestions_are_visible = visible
  if timer_id
    clearTimeout timer_id
    timer_id = null

is_down = (e) ->
  k = e.keyCode
  k is ferro.KEYS.CODES.PAGE_DOWN or
    k is ferro.KEYS.CODES.DOWN or
    ((e.altKey or e.ctrlKey) and (k is N or k is J))

is_up = (e) ->
  k = e.keyCode
  k is ferro.KEYS.CODES.PAGE_UP or
    k is ferro.KEYS.CODES.UP or
    ((e.altKey or e.ctrlKey) and (k is P or k is K))

set_entered = (e) ->
  entered = e
  $('f-entered-text').innerHtml = e

shortcut_matches = (e) ->
  e.keyCode is ferro.shortcut.key and
    e.altKey is ferro.shortcut.alt and
    e.ctrlKey is ferro.shortcut.ctrl and
    e.shiftKey is ferro.shortcut.shift

execute = ->
  main_i ?= suggestions[ferro.STATES.MAIN].selection
  main_choice ?= suggestions[ferro.STATES.MAIN].list[main_i]
  if main_choice.cmd
    send_cmd main_choice
  else
    cmd_i = suggestions[ferro.STATES.CMD].selection
    cmd_choice = suggestions[ferro.STATES.CMD].list[cmd_i]
    arg = text or main_choice
    send_cmd cmd_choice, arg
  close()

# if no arg, uses current tab
send_cmd = (choice, arg = null) ->
  chrome.extension.sendRequest
    action: execute
    fn: choice.cmd.fn
    arg: arg

close = ->
  state = ferro.STATES.INACTIVE
  set_entered ''
  context = null
  text = null
  $('f-box').style.opacity = 0
  $('f-main').className = 'f-selected' 
  $('f-cmd').className = ''
  $('f-text').value = ''
  $('f-text').style.visibility = 'hidden'

show = (id) ->
  $(id).style.visibility = 'visible'

ferro.get_type = (o) -> # see, wouldn't a class system be nice?
  if o.cmd
    ferro.CONTEXTS.COMMAND
  else if o.version
    if o.isApp then ferro.CONTEXTS.APP else ferro.CONTEXTS.EXTENSION
  else if o.dateAdded
    ferro.CONTEXTS.BOOKMARK
  else if o.index
    ferro.CONTEXTS.TAB
  else if o.wins
    ferro.CONTEXTS.SESSION
  else
    ferro.CONTEXTS.SPECIAL
  
switch_to_command = ->
  if text
    context = ferro.CONTEXTS.TEXT
  else
    main_i = suggestions[ferro.STATES.MAIN].selection
    main_choice = suggestions[ferro.STATES.MAIN].list[main_i]
    type = ferro.get_type main_choice
    if type is ferro.CONTEXTS.COMMAND
      return
    else
      context = type
  suggestions[ferro.STATES.CMD].list = ferro.COMMAND_NAMES[context]
  state = ferro.STATES.CMD
  set_entered ''
  set_suggestions_visibility false
  $('f-main').className = ''  #todo for text
  $('f-cmd').className = 'f-selected'
  
switch_from_command = ->
  state = if text then ferro.STATES.TEXT else ferro.STATES.MAIN
  set_entered ''

  set_suggestions_visibility false
  $('f-main').className = 'f-selected'
  $('f-text').focus() if text
  $('f-cmd').className = ''
  
d 'templates:', templates
$('body').append templates.ferro {suggestions, state, entered}

