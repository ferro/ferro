f.commands =
  extract:
    desc: "Extract tabs that match the given text into a new window. Uses the current tab's domain if text is blank."
    context: 'text'
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
    context: ['tab', 'text']
    fn: (current_tab, tab) ->
      if tab is ''
        tab = current_tab
      chrome.tabs.update tab.id, {pinned: true}
  unpin:
    desc: "Unpin tab. Uses current tab if text is blank."
    context: ['tab', 'text']
    fn: (current_tab, tab) ->
      if tab is ''
        tab = current_tab
      chrome.tabs.update tab.id, {pinned: false}
  select:
    desc: "Select tab."
    context: 'tab'
    fn: (x, tab) ->
      chrome.tabs.update tab.id, {selected: true}
  enable:
    context: ['extension', 'app']
    fn: (x, ext) ->
      chrome.management.setEnabled ext.id, true
  disable:
    context: ['extension', 'app']
    fn: (x, ext) ->
      chrome.management.setEnabled ext.id, false
  options:
    desc: 'Open the options page.'
    context: ['extension', 'app']
    fn: (x, ext) ->
      f.open ext.optionsUrl
  describe:
    context: ['extension', 'app']
    fn: (x, ext) ->
      f.display ext.description + ' -- Version: ' + ext.version
  homepage:
    context: ['extension', 'app']
    fn: (x, ext) ->
      f.open ext.homepageUrl
  launch:
    context: 'app'
    fn: (x, app) ->
      chrome.management.launchApp app.id
  uninstall:
    context: ['extension', 'app']
    fn: (x, ext) ->
      chrome.management.uninstall ext.id
  save:
    desc: "Save the current window with the name given."
    context: 'text'
    fn: (tab, name) ->
      chrome.windows.get tab.windowId, (win) ->
        f.sessions.add name, prepare win
  save_all:
    desc: "Save all open windows with the name given."
    context: 'text'
    fn: (x, name) ->
      chrome.windows.getAll {populate: true}, (wins) ->
        f.sessions.add name, prepare win for win in wins
  remove:
    desc: "Open saved session."
    context: 'session'
    fn: (x, session) ->
      open session #TODO

prepare = (win) ->
  _.extend _.copy(win, 'left', 'top', 'width', 'height'),
    url: _(win.tabs).pluck 'url'

move_to_new_window = (regex) ->
  for first_tab in f.tabs when regex.test tab.url
    chrome.windows.create {
      focused: true
      tabId: first_tab.id
    }, (win) =>
      first_tab.winId = win.id
      for tab in f.tabs when regex.test tab.url
        chrome.tabs.move tab.id {
          windowId: win.id
          index: 0
        }
    return

