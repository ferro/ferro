# update version when loaded
request = new XMLHttpRequest
request.open 'GET', chrome.extension.getURL('manifest.json'), false
request.send null
old_version = localStorage.version
localStorage.version = JSON.parse(request.responseText).version

# state

last_fn = last_arg = null
use_current_tab = false
    
window.update_cmd = (fn, arg, tab) ->
  use_current_tab = not arg
  last_arg = arg or tab

#  TODO simply assigning does not work. why is this? last_fn seems to be assigned correctly when viewed in the debugger, but when it is called in the key listener, it has no effect
  # here
#  last_fn = fn
  eval 'last_fn = ' + fn.toString()

  
# hotkey listener

chrome.commands.onCommand.addListener (command) ->
  chrome.tabs.getCurrent (tab) =>
    switch command
      when 'toggle_pin'
        if tab.pinned
          COMMANDS.unpin.fn tab
        else 
          COMMANDS.pin.fn tab
      when 'repeat_last_command'
        if last_fn
          if use_current_tab
            chrome.tabs.getSelected (tab) ->
              last_fn tab
          else
            last_fn last_arg
      else
        update_cmd fn, tab
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
