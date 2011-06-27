(function() {
  var port;
  port = chrome.extension.connect();
  window.onkeydown = function(e) {
    return port.postMessage(e);
  };
  port.onMessage.addListener(function(msg) {
    return log('b' + msg.toString());
  });
}).call(this);
