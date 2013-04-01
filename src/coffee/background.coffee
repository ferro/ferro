# update version when loaded
request = new XMLHttpRequest
request.open 'GET', chrome.extension.getURL('manifest.json'), false
request.send null
old_version = localStorage.version
localStorage.version = JSON.parse(request.responseText).version

chrome.commands.onCommand.addListener (command) ->
  chrome.tabs.getCurrent (tab) =>
    if command is 'toggle_pin'
      if tab.pinned
        COMMANDS.unpin.fn tab
      else 
        COMMANDS.pin.fn tab
    else
      COMMANDS[command].fn tab
