
# when first installed, init storage and ask them to set the keyboard shortcut
chrome.runtime.onInstalled.addListener (details) ->
  if details.reason is 'install'
    chrome.storage.sync.set {use_current_tab: false, donated: false}

# looks like the suggested shortcuts are set by default

    # chrome.windows.getLastFocused (cur) ->
    #   chrome.windows.create
    #     url: chrome.extension.getURL 'shortcut.html'
    #     top: cur.top + 200
    #     left: Math.round cur.left + cur.width/2 - 200
    #     width: 500
    #     height: 325
    #     type: 'popup'

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
        chrome.storage.sync.get ['last_fn', 'use_current_tab', 'last_arg'], (data) ->
          if data.last_fn
            if data.use_current_tab 
              COMMANDS[data.last_fn].fn tab
            else
              COMMANDS[data.last_fn].fn data.last_arg
      when 'duplicate'
        COMMANDS.duplicate.fn tab



# command helpers with callbacks that don't work inside of the browser action, which closes

window.create_window = (tab_ids) ->
  chrome.windows.create {
    focused: true
    tabId: tab_ids[0]
  }, (win) =>
    chrome.tabs.move tab_ids[1..], {
      windowId: win.id
      index: -1
    }
