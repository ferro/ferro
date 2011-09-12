# update version when loaded
request = new XMLHttpRequest
request.open 'GET', chrome.extension.getURL('manifest.json'), false
request.send null
old_version = localStorage.version
localStorage.version = JSON.parse(request.responseText).version

# if we haven't run before, then this was just installed, and currently-open tabs do not yet have our content script.
inject_background_scripts unless old_version

inject_content_scripts = ->
  chrome.windows.getAll {populate: true}, (wins) ->
    for win in wins
      for tab in win.tabs when tab.url.indexOf('http') is 0
        chrome.tabs.executeScript tab.id, {
          file: 'js/content-script.js',
          allFrames: true
        }

update_content_scripts = (keys...) = ->
  views = chrome.extension.getViews type: 'tab'
  view.f ?= {}
  view.f[key] = localStorage[key] for key in keys

update_content_scripts 'sessions', 'shortcut'

chrome.extension.onRequest.addListener (request, sender, sendResponse) ->
  switch request.action
    when 'delete'
      for s in localStorage['sessions'] when s.name isnt request.value
        localStorage['sessions'] = s 
    when 'create'
      localStorage['sessions'].concat request.value
  update_content_scripts 'sessions'

