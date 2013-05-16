# update version when loaded
request = new XMLHttpRequest
request.open 'GET', chrome.extension.getURL('manifest.json'), false
request.send null
old_version = localStorage.version
localStorage.version = JSON.parse(request.responseText).version

# hotkey listener

chrome.commands.onCommand.addListener (command) ->
  chrome.tabs.getCurrent (tab) =>
    if command is 'toggle_pin'
      if tab.pinned
        COMMANDS.unpin.fn tab
      else 
        COMMANDS.pin.fn tab
    else
      COMMANDS[command].fn tab

# command helpers with callbacks that don't work inside of the browser action

window.create_window = (tab_ids) ->
  chrome.windows.create {
    focused: true
    tabId: tab_ids[0]
  }, (win) =>
    chrome.tabs.move tab_ids[1..], {
      windowId: win.id
      index: -1
    }
