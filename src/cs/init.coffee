window.f = {}

f.open = (url) ->
  chrome.tabs.create {url}


