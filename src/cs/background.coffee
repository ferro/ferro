# update version when loaded
request = new XMLHttpRequest
request.open 'GET', chrome.extension.getURL('manifest.json'), false
request.send null
old_version = localStorage.version
localStorage.version = JSON.parse(request.responseText).version

unless localStorage.shortcut
  localStorage.shortcut = JSON.stringify
    key: f.KEYS.CODES.SPACE
    alt: true
    ctrl: true
    shift: false

# if we haven't run before, then this was just installed, and currently-open tabs do not yet have our content script.
inject_content_scripts unless old_version

inject_content_scripts = ->
  chrome.windows.getAll {populate: true}, (wins) ->
    for win in wins
      for tab in win.tabs when tab.url.indexOf('http') is 0
        chrome.tabs.executeScript tab.id, {
          file: 'js/content-script.js',
          allFrames: true
        }

convert_sessions = ->
  ss = []
  sessions.each (s) ->
    ss.push
      name: s.get 'name'
      wins: s.get 'wins'
  ss

update_content_scripts = (keys...) ->
  simple_sessions = convert_sessions() if _.include keys, 'sessions'
  views = chrome.extension.getViews type: 'tab'
  for view in views
    view.f ?= {}
    for key in keys
      switch key
        when 'sessions'
          view.f.sessions = simple_sessions
        else
          view.f[key] = JSON.parse localStorage[key]

sessions.fetch()

update_content_scripts 'sessions', 'shortcut'

chrome.extension.onRequest.addListener (request, sender, sendResponse) ->
  switch request.action
    when 'execute'
      arg = request.arg
      arg ?= sender.tab
      request.fn arg
    when 'update_shortcut'
      update_content_scripts 'shortcut'
        
