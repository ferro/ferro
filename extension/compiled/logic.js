(function() {
  chrome.extension.onConnect.addListener(function(port) {
    return port.onMessage.addListener(function(msg) {
      return port.postMessage('x');
    });
  });
}).call(this);
