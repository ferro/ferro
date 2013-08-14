
# when first installed, init storage and ask them to set the keyboard shortcut
chrome.runtime.onInstalled.addListener (details) ->
  if details.reason is 'install'
    localStorage.use_current_tab = false

    chrome.windows.getLastFocused (cur) ->
      chrome.windows.create
        url: chrome.extension.getURL 'shortcut.html'
        top: cur.top + 200
        left: Math.round cur.left + cur.width/2 - 200
        width: 500
        height: 325
        type: 'popup'

# hotkey listener
chrome.commands.onCommand.addListener (command) ->
  chrome.tabs.query {active: true, lastFocusedWindow: true}, ([tab]) ->
    switch command
      when 'toggle_pin'
        if tab.pinned
          COMMANDS.unpin.fn tab
        else 
          COMMANDS.pin.fn tab
      when 'repeat_last_command'
        if localStorage.last_fn
          if localStorage.use_current_tab is 'true'
            COMMANDS[localStorage.last_fn].fn tab
          else
            COMMANDS[localStorage.last_fn].fn localStorage.last_arg
      when 'duplicate'
        COMMANDS.duplicate.fn tab



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
