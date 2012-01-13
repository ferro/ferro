# update version when loaded
request = new XMLHttpRequest
request.open 'GET', chrome.extension.getURL('manifest.json'), false
request.send null
old_version = localStorage.version
localStorage.version = JSON.parse(request.responseText).version

unless localStorage.shortcut
  localStorage.shortcut = JSON.stringify
    key: ferro.KEYS.CODES.SPACE
    alt: true
    ctrl: true
    shift: false

get_tabs = (fn) ->
  chrome.windows.getAll populate: true, (wins) ->
    for win in wins
      for tab in win.tabs # when tab.url.indexOf('http') is 0
        fn tab
  

inject_content_scripts = ->
  d 'injecting'
  get_tabs (tab) ->
    d 'into ' + tab.url
    chrome.tabs.executeScript tab.id, {
      file: 'js/content.js',
      allFrames: true
    }

# if we haven't run before, then this was just installed, and currently-open tabs do not yet have our content script.
inject_content_scripts #unless old_version

convert_sessions = ->
  ss = []
  sessions.each (s) ->
    ss.push
      name: s.get 'name'
      wins: s.get 'wins'
  ss

update_content_scripts = (keys...) ->
  get_tabs (tab) ->
    update_tab tab.id, keys

update_tab = (tab_id, keys...) ->
  simple_sessions = convert_sessions() if _.include keys, 'sessions'
  request = {}
  for key in keys
    if key is 'sessions'
      request[key] = simple_sessions
    else
      request[key] = JSON.parse localStorage[key]
  chrome.tabs.sendRequest tab_id, request

sessions.fetch()

update_content_scripts 'sessions', 'shortcut'

chrome.extension.onRequest.addListener (request, sender, sendResponse) ->
  d 'request:'
  d request
  switch request.action
    when 'execute'
      arg = request.arg
      arg ?= sender.tab
      request.fn arg
    when 'update_shortcut'
      update_content_scripts 'shortcut'
    when 'get_state'
      update_tab sender.tab.id, 'sessions', 'shortcut'
