(function() {
  chrome.extension.onRequest.addListener(function(request, sender, sendResponse) {
    return sendResponse({
      value: localStorage[request.key]
    });
  });
}).call(this);
