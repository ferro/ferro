d = (z) ->
  console.log z
t = text

d 'test'










STATES =
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
    selection: null

NUM_SUGGESTIONS = 5

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
timer_id = null
suggestions_are_visible = false
apps = []
bookmarks = []
sessions = []

# css = document.createElement 'link'
# css.href = chrome.extension.getURL 'css/content-script.css'
# css.media = 'all'
# css.rel = 'stylesheet'
# css.type = 'text/css'
# document.getElementsByTagName('head')[0].appendChild css

# chrome.extension.onRequest.addListener (request, sender, sendResponse) ->
#   d 'setting:'
#   d request
#   _.extend ferro, request
        
# chrome.extension.sendRequest action: 'get_state'
    
$ = (id) ->
  if id[0] is '#'
    document.getElementById id[1..]
  else
    document.getElementsByTagName(id)[0]

window.onkeydown = (e) =>
  d e.keyCode
  d KEYS.CODES.RETURN
  return if e.keyCode is 91 #apple command key
  unless state is STATES.INACTIVE
    if e.keyCode is KEYS.CODES.RETURN and @entered
      execute()
      return
    else if e.keyCode is KEYS.CODES.ESC or shortcut_matches e
      close()
      return

  switch state
    when STATES.INACTIVE
      if shortcut_matches e
        d 'matches'
        refresh_all()
        state = STATES.MAIN
    when STATES.MAIN
      if e.keyCode is PERIOD
        $('#f-text').style.visibility = 'visible'
        $('#f-text').focus()
        state = STATES.TEXT
      else if e.keyCode is TAB
        switch_to_command()
        return false
      else if e.keyCode is BACKSPACE
        set_entered ''
        return false
      else if is_down(e) or is_up(e)
        update_selection is_down e
        return false
      else
        d 'else'
        update e
    when STATES.TEXT
      if e.keyCode is TAB
        text = $('#f-text').value
        switch_to_command()
        return false
    when STATES.CMD
      if e.keyCode is TAB
        switch_from_command()
        return false
      else if is_down(e) or is_up(e)
        update_selection is_down e
        return false
      else
        suggestions[state].selection or= 0
        update e
  
  # log 'down ' + String.fromCharCode e.keyCode
  # if _(keys.codes).chain().values().include(e.keyCode).value()
  #   log 'h'

  #  document.querySelector 'div.blah'

# todo race conditions - tame
refresh_all = ->
  d 'refresh_all'
  chrome.extension.sendRequest action: 'get_apps', (_apps) =>
    apps = _apps
  chrome.extension.sendRequest action: 'get_bookmarks',  (tree) =>
    d 'tree'
    d tree
    flatten_bookmarks tree[0]
  chrome.extension.sendRequest action: 'get_windows', (wins) =>
    tabs = (tab for tab in _.flatten(win.tabs for win in wins)) #when regex.test tab.url
    suggestions[STATES.MAIN].list = COMMAND_NAMES[CONTEXTS.MAIN]
      .concat tabs
      .concat apps
      .concat sessions
      .concat bookmarks
      .concat SPECIAL_PAGES
    if $ '#ferro'
      $('#f-box').style.opacity = 1
    else
      append_template()

flatten_bookmarks = (node) ->
  if node.children
    unless node.children.length is 0
      flatten_bookmarks child for child in node.children
  else
    bookmarks.push node

update_selection = (down) -> 
  d 'update_selection'
  d down
  unless suggestions_are_visible
    display_suggestions()
  d suggestions
  d state
  d 'cur'
  cur = suggestions[state].selection
  d cur
#  $('#f-' + cur).className = 'f-suggest';
  if down
    cur = (cur + 1) % NUM_SUGGESTIONS
  else
    cur = (cur - 1 + NUM_SUGGESTIONS) % NUM_SUGGESTIONS
#  $('#f-' + cur).className += ' f-selected';
  d cur
  suggestions[state].selection = cur
  display_suggestions()

show_suggestions = =>
  suggestions_are_visible = true # done early to diminish race
  display_suggestions()
  
update = (e) ->
  suggestions[state].selection = 0
  c = String.fromCharCode e.keyCode
  d c

  # don't do anything with unprintable chars
  return if not c or e.altKey or e.ctrlKey or e.shiftKey 

  d c
  unless suggestions_are_visible
    if timer_id # very minor race condition
      clearTimeout timer_id
    timer_id = setTimeout (-> show_suggestions()), 600
  set_entered entered + c
  re_sort()

gear_icon = chrome.extension.getURL 'images/gear.png'
page_icon = chrome.extension.getURL 'images/page.ico'
pages_icon = chrome.extension.getURL 'images/pages.ico'
filter = _.filter
  
append_template = ->
  d 'templ el:'
  tem = templates.ferro {suggestions, state, entered: entered.toLowerCase(), ferro, gear_icon, page_icon, pages_icon, filter}
  div = document.createElement 'div'
  div.innerHTML = tem
  div.id = 'ferro-container'
  d div
  $('body').appendChild div

display_suggestions = ->
  felem = $ '#ferro-container'
  body = $ 'body'
  append_template()
  body.removeChild felem if felem
  set_suggestions_visibility true

re_sort = ->
  d bookmarks
  suggestions[state].list = _.sortBy suggestions[state].list, (s) =>
#     x = s.name or s.title or s.url
# #    d s
#     x.charCodeAt(0)

    # everything has a name except for tabs
    if s.name
      weight = s.name.score entered
    else
      weight = _.max [s.title?.score entered, s.url?.score entered]
    1 - weight 

  # for s in suggestions[state].list
  #   if s.name
  #     weight = s.name.score entered
  #   else
  #     weight = _.max [s.title?.score entered, s.url?.score entered]
  #   d 1 - weight 
  if suggestions_are_visible
    display_suggestions()

set_suggestions_visibility = (visible) ->
  d 'set_suggestions_visibility'
  $('#f-suggestions').style.opacity = if visible then 1 else 0
  suggestions_are_visible = visible
  if timer_id
    clearTimeout timer_id
    timer_id = null

is_down = (e) ->
  k = e.keyCode
  k is KEYS.CODES.PAGE_DOWN or
    k is KEYS.CODES.DOWN or
    ((e.altKey or e.ctrlKey) and (k is N or k is J))

is_up = (e) ->
  k = e.keyCode
  k is KEYS.CODES.PAGE_UP or
    k is KEYS.CODES.UP or
    ((e.altKey or e.ctrlKey) and (k is P or k is K))

# todo remove?
set_entered = (e) ->
  entered = e
  $('#f-entered-text').innerHTML = e.toLowerCase()

shortcut_matches = (e) ->
  e.keyCode is shortcut.key and
    e.altKey is shortcut.alt and
    e.ctrlKey is shortcut.ctrl and
    e.shiftKey is shortcut.shift

execute = ->
  main_i ?= suggestions[STATES.MAIN].selection
  main_choice ?= suggestions[STATES.MAIN].list[main_i]
  if main_choice.cmd
    send_cmd main_choice.cmd
  else
    cmd_i = suggestions[STATES.CMD].selection
    cmd_choice = suggestions[STATES.CMD].list[cmd_i]?.cmd
    d 'cmd_choice', cmd_choice
    cmd_choice or= DEFAULTS[get_type main_choice]
    d cmd_choice
    arg = text or main_choice
    send_cmd cmd_choice, arg #here
  close()

# if no arg, uses current tab
send_cmd = (choice, arg = null) ->
  chrome.extension.sendRequest
    action: execute
    fn: choice.fn
    arg: arg

close = ->
  d 'CLOSING'
  set_suggestions_visibility false
  state = STATES.INACTIVE
  set_entered ''
  context = null
  text = null
  $('#f-box').style.opacity = 0
  $('#f-main').className = 'f-selected' 
  $('#f-cmd').className = ''
  $('#f-text').value = ''
  $('#f-text').style.visibility = 'hidden'

get_type = (o) -> # see, wouldn't a class system be nice?
  if o?.cmd
    CONTEXTS.COMMAND
  else if o?.version
    if o?.isApp then CONTEXTS.APP else CONTEXTS.EXTENSION
  else if o?.dateAdded
    CONTEXTS.BOOKMARK
  else if o?.index
    CONTEXTS.TAB
  else if o?.wins
    CONTEXTS.SESSION
  else
    CONTEXTS.SPECIAL
  
switch_to_command = ->
  if text
    context = CONTEXTS.TEXT
  else
    main_i = suggestions[STATES.MAIN].selection
    main_choice = suggestions[STATES.MAIN].list[main_i]
    type = get_type main_choice
    if type is CONTEXTS.COMMAND
      return
    else
      context = type
  suggestions[STATES.CMD].list = COMMAND_NAMES[context]
  state = STATES.CMD
  set_entered ''
  set_suggestions_visibility false
  $('#f-main').className = ''  #todo for text
  $('#f-cmd').className = 'f-selected'
  
switch_from_command = ->
  state = if text then STATES.TEXT else STATES.MAIN
  set_entered ''

  set_suggestions_visibility false
  $('#f-main').className = 'f-selected'
  $('#f-text').focus() if text
  $('#f-cmd').className = ''
  














bold_entered = (to_bold) ->
  @entered = @entered.toLowerCase()
  to_bold_lower = to_bold.toLowerCase()
  last = 0
  for c in @entered
    i = to_bold_lower[last..].indexOf c
    if i is -1
      t to_bold[last..]
      return
    else
      if i isnt 0
        t to_bold[last..last+i-1] 
      b to_bold[last+i] 
      last += i + 1
      if last is to_bold.length
        return
  t to_bold[last..]

get_icon = (o, accept_array = false) ->
  return null unless o
  switch @get_type o
    when @CONTEXTS.COMMAND 
      @gear_icon      
    when @CONTEXTS.SPECIAL
      @page_icon
    when @CONTEXTS.BOOKMARK
      'chrome://favicon/' + o.url
    when @CONTEXTS.APP, @CONTEXTS.EXTENSION
      icons = @filter o.icons, (i) ->
        i.size is 16
      icons[0].url
    when @CONTEXTS.TAB
      o.favIconUrl
    when @CONTEXTS.SESSION
      if accept_array #todo 
        o.wins.icons
      else
        @pages_icon
    else
      null

get_name = (o) ->
  o?.name or o?.title      

get_desc = (o) ->
  desc = o?.cmd?.desc or o?.desc or o?.description
  if o?.url
    if o?.url[0..6] is 'http://'
      desc = o?.url[7..-1]
    else if o?.url[0..7] is 'https://'
      desc = o?.url[8..-1]
    else
      desc = o?.url
#  desc[0..39] if desc
  desc

template = ->
  doctype 5
  html ->
    body ->
      div id: 'ferro', ->
        div id: 'f-box', ->
          visibility = if @text then 'visible' else 'hidden'
          textarea id: 'f-text', cols: '20', rows: '4', style: 'visibility: ' + visibility
          main_klass = ''
          cmd_klass = ''
          if @state is @STATES?.MAIN
            main_klass = 'f-selected'
            cmd_klass = ''
          else
            main_klass = ''
            cmd_klass = 'f-selected'
          div id: 'f-main', class: main_klass, ->
            sugs = @suggestions[@STATES?.MAIN]
            if @entered
              main = sugs?.list[sugs?.selection] 
            d 'ferro'
            d sugs
            d main
            icon = get_icon main
            if icon
              img id: 'f-icon-main', src: icon, width: '16px', height: '16px'
            div id: 'f-name-main', ->
              if main
                n = get_name main
                console.log 'entered:'
                bold_entered n #here
              else
                t ''
            div id: 'f-description-main', ->
              t get_desc main if main
          div id: 'f-cmd', class: cmd_klass, ->
            sugs = @suggestions[@STATES?.CMD]
            cmd = sugs?.list[sugs.selection]
            div id: 'f-name-cmd', ->
              t get_name(cmd) or ''
            div id: 'f-description-cmd', ->
              t cmd?.cmd?.desc or ''
        div id: 'f-suggestions', ->
          div id: 'f-entered', ->
            span id: 'f-entered-text', ->
              t @entered
          for i in [0..@NUM_SUGGESTIONS-1]
            cur = @suggestions[@state]?.list[i]
            klass = 'f-suggest'
            klass += ' f-selected' if i is @suggestions[@state]?.selection
            div id: 'f-' + i, class: klass, ->
              icon = get_icon cur
              if icon
                img class: 'f-icon', src: icon, width: '16px', height: '16px'
              div class: 'f-title', ->
                t get_name cur
              div class: 'f-url', ->
                t get_desc cur


# cc = require 'coffeecup'
# console.log cc.render template, {}, { locals: { Backbone: Backbone } }
