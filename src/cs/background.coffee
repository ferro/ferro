chrome.extension.onRequest.addListener (request, sender, sendResponse) ->
  sendResponse
    value: localStorage[request.key]
