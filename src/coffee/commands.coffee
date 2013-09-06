if module?.exports
  {sentence_case} = require './init'

CONTEXTS = # tied to DEFAULTS
  TAB: 0
  EXTENSION: 1
  APP: 2
  SESSION: 3
  TEXT: 4
  SPECIAL: 5
  BOOKMARK: 6
  MAIN: 7
  COMMAND: 8
  HISTORY: 9

DEFAULTS =  # tied to CONTEXTS
  0: 'select'
  1: 'options'
  2: 'launch'
  3: 'open'
  4: 'extract'
  5: 'open'
  6: 'open'
  7: null
  8: null
  9: 'open'
  
# don't add commands that have keyboard shortcuts by default, like close tab, close window, and create bookmark
COMMANDS =
  speak:
    desc: 'Speak aloud the given text'
    context: [CONTEXTS.TEXT]
    fn: (text) ->
      chrome.tts.speak text
  duplicate:
    desc: 'Duplicate tab'
    context: [CONTEXTS.TAB, CONTEXTS.MAIN]
    fn: (tab) ->
      chrome.tabs.create _.copy(tab, 'windowId', 'index', 'url')
  reload_all_tabs:
    desc: 'Reload every tab in every window'
    context: CONTEXTS.MAIN
    fn: (x) ->
      chrome.windows.getAll { populate: true }, (wins) ->
        reload_window win for win in wins
  reload_all_tabs_in_window:
    desc: 'Reload every tab in this window'
    context: CONTEXTS.MAIN
    fn: (x) ->
      chrome.windows.getLastFocused { populate: true }, (win) ->
        reload_window win
  search_history:
    desc: 'Search through your history for the given text'
    context: CONTEXTS.TEXT
    fn: (text) ->
      tab_open 'chrome://history/#q=' + text
  extract:
    desc: "Extract tabs that match the given text or the given tab's domain into a new window"
    context: [CONTEXTS.TEXT, CONTEXTS.MAIN, CONTEXTS.TAB]
    fn: (text) ->
      apply_to_matching_tabs text, (tabs) =>
        if tabs and tabs.length > 0
          chrome.runtime.getBackgroundPage (win) ->
            win.create_window _.pluck(tabs, 'id')
  close:
    desc: "Close tabs that match the given text or the given tab's domain"
    context: [CONTEXTS.TEXT, CONTEXTS.MAIN, CONTEXTS.TAB]
    fn: (text) ->
      apply_to_matching_tabs text, (tabs) ->
        chrome.tabs.remove tab.id for tab in tabs
  kill:
    desc: "Kill tabs that match the given text or the given tab's domain"
    context: [CONTEXTS.TEXT, CONTEXTS.MAIN, CONTEXTS.TAB]
    fn: (text) ->
      apply_to_matching_tabs text, (tabs) ->
        kill tab.id for tab in tabs
  kill_all:
    desc: 'Kill all tabs'
    context: CONTEXTS.MAIN
    fn: (x) ->
      chrome.windows.getAll { populate: true }, (wins) ->
        (kill tab.id for tab in win.tabs) for win in wins
  pin:
    desc: 'Pin tab'
    context: [CONTEXTS.TAB, CONTEXTS.MAIN]
    fn: (tab) ->
      chrome.tabs.update tab.id, {pinned: true}
  unpin:
    desc: 'Unpin tab'
    context: [CONTEXTS.TAB, CONTEXTS.MAIN]
    fn: (tab) ->
      chrome.tabs.update tab.id, {pinned: false}
  select:
    desc: 'Select tab'
    context: CONTEXTS.TAB
    fn: (tab) ->
      chrome.tabs.update tab.id, {selected: true}
  enable:
    desc: 'Enable extension or app'
    context: [CONTEXTS.EXTENSION, CONTEXTS.APP]
    fn: (ext) ->
      chrome.management.setEnabled ext.id, true
  disable:
    desc: 'Disable extension or app'
    context: [CONTEXTS.EXTENSION, CONTEXTS.APP]
    fn: (ext) ->
      chrome.management.setEnabled ext.id, false
  options:
    desc: 'Open the options page of an extension or app'
    context: [CONTEXTS.EXTENSION, CONTEXTS.APP]
    fn: (ext) ->
      tab_open ext.optionsUrl
  describe:
    desc: 'Show description of extension or app'
    context: [CONTEXTS.EXTENSION, CONTEXTS.APP]
    fn: (ext) ->
      display_message ext.description + ' -- Version: ' + ext.version
  homepage:
    desc: 'Open homepage of extension or app'
    context: [CONTEXTS.EXTENSION, CONTEXTS.APP]
    fn: (ext) ->
      tab_open ext.homepageUrl
  launch:
    desc: 'Launch app'
    context: CONTEXTS.APP
    fn: (app) ->
      chrome.management.launchApp app.id
  uninstall:
    desc: 'Uninstall extension or app'
    context: [CONTEXTS.EXTENSION, CONTEXTS.APP]
    fn: (ext) ->
      chrome.management.uninstall ext.id, {showConfirmDialog: true}
  add:
    desc: 'Add current tab to session'
    context: CONTEXTS.SESSION
    fn: (session) ->
      chrome.tabs.query {active: true, currentWindow: true}, ([tab]) =>
        s = sessions.get_by_name session.get('name')
        wins = s.get 'wins' 
        wins[0].urls.push tab.url
        wins[0].pins.push tab.pinned
        wins[0].icons.push tab.favIconUrl
        s.save {wins}
  save:
    desc: 'Save the current window with the name given'
    context: CONTEXTS.TEXT
    fn: (name) ->
      chrome.windows.getLastFocused {populate: true}, (win) =>
        save_session name, [prepare win]
  save_all:
    desc: 'Save all open windows with the name given'
    context: CONTEXTS.TEXT
    fn: (name) ->
      chrome.windows.getAll {populate: true}, (wins) =>
        save_session name, (prepare win for win in wins)
  open:
    desc: 'Open saved session, bookmark, history item, or special page'
    context: [CONTEXTS.SESSION, CONTEXTS.SPECIAL, CONTEXTS.BOOKMARK, CONTEXTS.HISTORY]
    fn: (page) ->
      if page.constructor.name is 'Session'
        # it's actually a session. typechecking for other classes would be nice...
        open_session page
      else if page.url
        tab_open page.url
      else
        folder = page
        chrome.bookmarks.getChildren folder.id, (pages) ->
          if pages.length > 20
            return unless confirm "Open all #{pages.length} tabs in bookmark folder?"
          tab_open page.url for page in pages 
  delete:
    desc: 'Delete session or bookmark'
    context: [CONTEXTS.SESSION, CONTEXTS.BOOKMARK]
    fn: (bookmark) ->
      if bookmark.constructor.name is 'Session'
        sessions.get_by_name(bookmark.get('name')).destroy()
      else if bookmark.children and bookmark.children.length isnt 0
        chrome.bookmarks.removeTree bookmark.id if confirm "Recursively delete all #{bookmark.children.length} bookmarks in folder?"
      else
        chrome.bookmarks.remove bookmark.id

if module?.exports
  exports.COMMANDS = COMMANDS

COMMANDS_BY_CONTEXT = []

# load COMMANDS_BY_CONTEXT 2D array
for name, cmd of COMMANDS
  context = cmd.context
  context = [context] unless context instanceof Array
  for c in context
    COMMANDS_BY_CONTEXT[c] or= []
    COMMANDS_BY_CONTEXT[c].push {name: sentence_case(name), cmd: cmd} 

# add name to COMMANDS
for name, cmd of COMMANDS
  cmd.name = name
  
equals_ignore_case = (a,b) ->
  a.replace('_',' ').toLowerCase() is b.replace('_',' ').toLowerCase()
 
push_to_top = (list, cmd) ->
  list = _.reject( list, ((o) => equals_ignore_case(o.name, cmd)))
  list.unshift  {name: sentence_case(cmd), cmd: COMMANDS[cmd]}
  list

# put defaults first
# needs to only be called in browser, because needs underscore
init_commands_by_context = () ->
  for i, cmd of DEFAULTS
    if cmd
      COMMANDS_BY_CONTEXT[i] = push_to_top COMMANDS_BY_CONTEXT[i], cmd

prepare = (win) ->
  _.extend _.copy(win, 'left', 'top', 'width', 'height', 'focused'),
    urls: _(win.tabs).pluck 'url'
    pins: _(win.tabs).pluck 'pinned' #or just save a count?
    icons: _(win.tabs).pluck 'favIconUrl'

starts_with = (str, starts) ->
  str.length >= starts.length and str.slice(0, starts.length) is starts

apply_to_matching_tabs = (text, fn) ->
  if text.url #is a tab
    tab = text
    if (starts_with tab.url, 'chrome') or (starts_with tab.url, 'about')
      apply_to_regex_tabs /^(chrome|about)/, fn
    else
      http = '^https*://'
      d tab.url
      d tab.url.match(new RegExp(http + '(.*\..{2,4}/)', 'i'))
      domain = tab.url.match(new RegExp(http + '(.*\..{2,4}/)', 'i'))[1]
      d domain  
      apply_to_regex_tabs(new RegExp(http + domain, 'i'), fn) if domain
  else
    apply_to_regex_tabs new RegExp(text, 'i'), fn

apply_to_regex_tabs = (regex, fn) ->
  chrome.windows.getAll {populate: true}, (wins) =>
    d 'wins'
    d wins
    tabs = (tab for tab in _.flatten(win.tabs for win in wins) when ((regex.test tab.url) or (regex.test tab.title)))
    fn tabs
  
open_session = (session) ->
  for win in session.get('wins')
    win.url = win.urls
    chrome.windows.create _.omit(win, 'urls', 'pins', 'icons'), (new_win) =>
      for i in [0...win.urls.length]
        chrome.tabs.update new_win.tabs[i].id, {pinned: win.pins[i]}
      chrome.tabs.update new_win.tabs[0].id, {active: true}

save_session = (name, wins) ->
  s = sessions.get_by_name name
  if s
    s.destroy()
  s = new Session {name, wins}
  sessions.add s
  s.save()
  
reload_window = (win) ->
  chrome.tabs.update(tab.id, url: tab.url) for tab in win.tabs

kill = (id) ->
  chrome.tabs.update id, url: 'about:kill'

