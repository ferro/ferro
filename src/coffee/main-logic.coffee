STATES =
  MAIN: 1
  TEXT: 2
  CMD: 3

suggestions =
  1: #main
    list: []
    selection: null
  3: #cmd
    list: []
    selection: null

main = suggestions[STATES.MAIN]
command = suggestions[STATES.CMD]

NUM_SUGGESTIONS = 5

PERIOD = 46
TAB = 9
BACKSPACE = 8
N = 78
P = 80
J = 74
K = 75

state = STATES.MAIN
text_entered = ''
context = null
main_i = -2
main_choice = null
text_mode_text = null
timer_id = null
suggestions_are_visible = false
bookmarks = []
sessions = null

gear_icon = chrome.extension.getURL 'images/gear.png'
page_icon = chrome.extension.getURL 'images/page.ico'
pages_icon = chrome.extension.getURL 'images/pages.ico'
filter = _.filter # needs to be un-underscored global var for template

$f = (id) ->
  if id[0] is '#'
    document.getElementById id[1..]
  else
    document.getElementsByTagName(id)[0]

is_down = (e) ->
  k = e.keyCode
  k is KEYS.CODES.PAGE_DOWN or
    k is KEYS.CODES.DOWN or
    ((e.altKey or e.ctrlKey) and (k is KEYS.CODES.N or k is KEYS.CODES.J))


in_text_mode = () ->
  text_mode_text?.constructor?.name is 'String'

# need some delay between calling this and user entering text
load_data = ->
  sessions = new SessionList
  sessions.fetch()
  chrome.management.getAll (apps) =>
    chrome.bookmarks.getTree (tree) =>
      flatten_bookmarks tree[0]
      chrome.windows.getAll populate: true, (wins) =>
        tabs = (tab for tab in _.flatten(win.tabs for win in wins)) 
        main.list = COMMANDS_BY_CONTEXT[CONTEXTS.MAIN]
          .concat tabs
          .concat apps
          .concat sessions.models
          .concat bookmarks
          .concat SPECIAL_PAGES

flatten_bookmarks = (node) ->
  if node.children
    unless node.children.length is 0
      flatten_bookmarks child for child in node.children
  else
    bookmarks.push node

update_selection = (down) -> 
  unless suggestions_are_visible
    display_suggestions()
  cur = suggestions[state].selection

  mod = Math.min NUM_SUGGESTIONS, suggestions[state].list.length

  if down
    cur = (cur + 1) % mod
  else
    cur = (cur - 1 + mod) % mod

  suggestions[state].selection = cur

  if state is STATES.MAIN
    command.selection = null
  display_suggestions()

show_suggestions = =>
  suggestions_are_visible = true # done early to diminish race
  display_suggestions()
  
update = (e) ->
  suggestions[state].selection = 0
  c = String.fromCharCode e.charCode

  # don't do anything with unprintable chars
  return if not c or e.altKey or e.ctrlKey

  unless suggestions_are_visible
    if timer_id # very minor race condition
      clearTimeout timer_id
    timer_id = setTimeout (-> show_suggestions()), 200
  set_entered text_entered + c

  switch state
    when STATES.MAIN
      chrome.history.search {text: text_entered, maxResults: 5}, (results) =>
        suggestions[state].list = suggestions[state].list.concat results
        re_sort()
    when STATES.CMD
      re_sort()


  
re_sort = ->
  suggestions[state].list = _.sortBy suggestions[state].list, (s) =>

    # everything has a name except for tabs
    if s.name 
      weight = s.name.score text_entered
    else if s.get #session
      weight = s.get('name').score text_entered
    else
      weight = _.max [s.title?.score text_entered, s.url?.score text_entered]
    1 - weight 

  if suggestions_are_visible
    display_suggestions()

set_suggestions_visibility = (visible) ->
  $f('#f-suggestions').style.opacity = if visible then 1 else 0
  suggestions_are_visible = visible
  if visible
    $('body').addClass('full')
  else
    $('body').removeClass('full')
  if timer_id
    clearTimeout timer_id
    timer_id = null

is_up = (e) ->
  k = e.keyCode
  k is KEYS.CODES.PAGE_UP or
    k is KEYS.CODES.UP or
    ((e.altKey or e.ctrlKey) and (k is KEYS.CODES.P or k is KEYS.CODES.K))

set_entered = (e) ->
  text_entered = e
  $f('#f-entered-text').innerHTML = e.toLowerCase()

execute = ->
  if not in_text_mode() and main_choice().cmd
    send_cmd main_choice().cmd
    window.close()
  else
    cmd = if cmd_choice()
      cmd_choice()
    else if in_text_mode()
      COMMANDS[DEFAULTS[CONTEXTS.TEXT]]
    else
      COMMANDS[DEFAULTS[get_type main_choice()]]
    arg = main_choice()
    if in_text_mode()
      arg = $f('#f-text').value
    send_cmd cmd, arg
    
    unless cmd.name is 'describe'
      window.close()


update_stored_cmd = (fn_name, arg, tab) ->
  chrome.storage.sync.set
    use_current_tab: not arg
    last_arg: arg or tab
    last_fn: fn_name

# if no arg, uses current tab
send_cmd = (cmd, arg = null) ->
  chrome.tabs.query {active: true, currentWindow: true}, ([tab]) ->
    update_stored_cmd cmd.name, arg, tab
    final_arg = arg or tab
    track 'Commands', cmd.name, get_type final_arg
    cmd.fn final_arg

get_type = (o) -> # see, wouldn't a class system be nice?
  return null unless o 

  if _.isString o
    CONTEXTS.TEXT
  else if 'cmd' of o
    CONTEXTS.COMMAND
  else if 'version' of o
    if o?.isApp then CONTEXTS.APP else CONTEXTS.EXTENSION
  else if 'dateAdded' of o
    CONTEXTS.BOOKMARK
  else if 'index' of o
    CONTEXTS.TAB
  else if 'get' of o
    CONTEXTS.SESSION
  else if 'id' of o
    CONTEXTS.HISTORY
  else
    CONTEXTS.SPECIAL
  
switch_to_command = ->
  if in_text_mode()
    context = CONTEXTS.TEXT
  else
    type = get_type main_choice()
    if type is CONTEXTS.COMMAND
      return
    else
      context = type
  
  if command.selection is null
    command.list = COMMANDS_BY_CONTEXT[context]
  
  state = STATES.CMD
  set_entered ''
  set_suggestions_visibility false
  $f('#f-main').className = ''
  $f('#f-cmd').className = 'f-selected'
  
focus_text = () ->
  $f('#f-text').focus()
  box = $('#f-text')
  len = box.val().length
  $f('#f-text').setSelectionRange len, len

switch_to_main = ->
  state = if in_text_mode() then STATES.TEXT else STATES.MAIN
  set_entered ''

  $f('#f-main').className = 'f-selected'
  $f('#f-cmd').className = ''
  append_template()
  if in_text_mode()
    focus_text()
  else
    set_suggestions_visibility true

switch_to_text = ->
  text_mode_text = ''
  window.setTimeout ->
    $f('#f-text').value = ''
  , 10
  $f('#f-text').style.visibility = 'visible'
  $f('#f-text').focus()
  state = STATES.TEXT
  main.selection = command.selection = null
  main.list = command.list = []
  set_entered ''
  set_suggestions_visibility false
  
append_template = =>
  body = $f('body')
  if body.firstChild
    body.removeChild body.firstChild
  div = document.createElement 'div'
  html = coffeecup.render popup_template, {
    text_mode_text, state, STATES, suggestions, text_entered: text_entered.toLowerCase(), NUM_SUGGESTIONS, gear_icon, page_icon, pages_icon, filter, in_text_mode
  }, hardcode: helpers
  div.innerHTML = html
  div.id = 'ferro-container'
  body.appendChild div
  $f('#f-text').value = text_mode_text
  if state is STATES.TEXT
    focus_text()

display_suggestions = (visible = true)->
  append_template()
  set_suggestions_visibility visible

main_choice = ->
  main_i = main.selection
  main.list[main_i]

cmd_choice = ->
  cmd_i = command.selection
  command.list[cmd_i]?.cmd

update_default_cmd = ->
  setTimeout ->
    if (state is STATES.CMD) and (command.selection isnt null)
      return
    if main_choice()
      context = get_type main_choice()
    else if state is STATES.TEXT
      context = CONTEXTS.TEXT
      text_mode_text = $f('#f-text').value
    if DEFAULTS[context]
      command.list = COMMANDS_BY_CONTEXT[context]
      command.selection = 0
    else
      command.list = []
      command.selection = null
    display_suggestions state isnt STATES.TEXT
  , 500

clear_cmd = ->
  command.selection = null
  display_suggestions()

ready_to_execute = ->
  text_entered or $f('#f-text').value or (command.selection isnt null)

is_transition = (key) ->  
  _([TAB, KEYS.CODES.LEFT, KEYS.CODES.RIGHT]).contains key.keyCode
  
# STATE machine
window.onkeydown = (key) =>
  if key.keyCode is KEYS.CODES.RETURN and ready_to_execute()
    execute()
    return

  switch state
    when STATES.MAIN
      if is_transition key
        switch_to_command()
      else if key.keyCode is BACKSPACE
        set_entered ''
        clear_cmd()
      else if is_down(key) or is_up(key)
        update_selection is_down key
        update_default_cmd()
    when STATES.TEXT
      if is_transition key
        text_mode_text = $f('#f-text').value
        $f('#f-cmd').focus()
        switch_to_command()
    when STATES.CMD
      if is_transition key
        switch_to_main()
        key.preventDefault()
      else if key.keyCode is BACKSPACE
        set_entered ''
        clear_cmd()
      else if is_down(key) or is_up(key)
        update_selection(is_down key) if cmd_choice()

window.onkeypress = (key) =>

  # ctrl-j,k,n,p are handled in onkeydown
  if _.contains [10,11,14,16], key.keyCode
    return

  switch state
    when STATES.MAIN
      if key.charCode is PERIOD
        switch_to_text()
        update_default_cmd()
      else 
        update key
        update_default_cmd()
    when STATES.CMD
      suggestions[state].selection or= 0
      update key
      key.preventDefault() # prevents character briefly showing up in #f-text
  

