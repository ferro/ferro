# update version when loaded
request = new XMLHttpRequest
request.open 'GET', chrome.extenstion.getURL('manifest.json'), false
request.send null
old_version = localStorage.version
inject_background_scripts unless old_version
localStorage.version = JSON.parse(request.responseText).version

inject_background_scripts = ->
  chrome.windows.getAll {populate: true}, (wins) ->
    for win in wins
      for tab in win.tabs when tab.url.indexOf('http') is 0
        chrome.tabs.executeScript tab.id, {
          file: 'js/background_script.js',
          allFrames: true
        }

chrome.extension.onRequest.addListener (request, sender, sendResponse) ->
  sendResponse
    value: localStorage[request.key]
