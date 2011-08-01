todo search history

f.CONTEXTS =
  TAB: 0
  EXTENSION: 1
  APP: 2
  SESSION: 3
  TEXT: 4

f.commands =
  extract:
    desc: "Extract tabs that match the given text into a new window. Uses the current tab's domain if text is blank."
    context: f.CONTEXTS.TEXT
    fn: (tab, text) ->
      if text is ''
        if _(tab.url).startsWith 'chrome' or _(tab.url).startsWith 'about'
          move_to_new_window /^(chrome|about)/
        else
          http = '^https*://'
          domain = tab.url.match(new RegExp(http + '(.*\..{2,4}/)', 'i'))[1]
          move_to_new_window new RegExp(http + domain, 'i')
      else
        move_to_new_window new RegExp(text, 'i')
  pin:
    desc: "Pin tab. Uses current tab if text is blank."
    context: [f.CONTEXTS.TAB, f.CONTEXTS.TEXT]
    fn: (current_tab, tab) ->
      if tab is ''
        tab = current_tab
      chrome.tabs.update tab.id, {pinned: true}
  unpin:
    desc: "Unpin tab. Uses current tab if text is blank."
    context: [f.CONTEXTS.TAB, f.CONTEXTS.TEXT]
    fn: (current_tab, tab) ->
      if tab is ''
        tab = current_tab
      chrome.tabs.update tab.id, {pinned: false}
  select:
    desc: "Select tab."
    context: f.CONTEXTS.TAB
    fn: (x, tab) ->
      chrome.tabs.update tab.id, {selected: true}
  enable:
    context: [f.CONTEXTS.EXTENSION, f.CONTEXTS.APP]
    fn: (x, ext) ->
      chrome.management.setEnabled ext.id, true
  disable:
    context: [f.CONTEXTS.EXTENSION, f.CONTEXTS.APP]
    fn: (x, ext) ->
      chrome.management.setEnabled ext.id, false
  options:
    desc: 'Open the options page.'
    context: [f.CONTEXTS.EXTENSION, f.CONTEXTS.APP]
    fn: (x, ext) ->
      f.open ext.optionsUrl
  describe:
    context: [f.CONTEXTS.EXTENSION, f.CONTEXTS.APP]
    fn: (x, ext) ->
      f.display ext.description + ' -- Version: ' + ext.version
  homepage:
    context: [f.CONTEXTS.EXTENSION, f.CONTEXTS.APP]
    fn: (x, ext) ->
      f.open ext.homepageUrl
  launch:
    context: f.CONTEXTS.APP
    fn: (x, app) ->
      chrome.management.launchApp app.id
  uninstall:
    context: [f.CONTEXTS.EXTENSION, f.CONTEXTS.APP]
    fn: (x, ext) ->
      chrome.management.uninstall ext.id
  save:
    desc: "Save the current window with the name given."
    context: f.CONTEXTS.TEXT
    fn: (tab, name) ->
      chrome.windows.get tab.windowId, (win) ->
        f.sessions.add name, prepare win
  save_all:
    desc: "Save all open windows with the name given."
    context: f.CONTEXTS.TEXT
    fn: (x, name) ->
      chrome.windows.getAll {populate: true}, (wins) ->
        f.sessions.add name, prepare win for win in wins
  open:
    desc: "Open saved session."
    context: f.CONTEXTS.SESSION
    fn: (x, session) ->
      open session #TODO
  remove:
    desc: "Delete saved session."
    context: f.CONTEXTS.SESSION
    fn: (x, session) ->
      open session #TODO

prepare = (win) ->
  _.extend _.copy(win, 'left', 'top', 'width', 'height'),
    url: _(win.tabs).pluck 'url'

move_to_new_window = (regex) ->
  tabs = get_tabs regex
  chrome.windows.create {
    focused: true
    tabId: tabs[0].id
  }, (win) =>
    chrome.tabs.move tabs[i].id, {
      windowId: win.id
      index: 0
    } for i in [1..tabs.length]

get_tabs = (regex) ->
  chrome.windows.getAll {populate: true}, (wins) ->
    # map + flatten + filter (regex.text tab.url) wins.tabs
