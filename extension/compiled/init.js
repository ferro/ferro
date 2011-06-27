(function() {
  window.f = {};
  f.open = function(url) {
    return chrome.tabs.create({
      url: url
    });
  };
}).call(this);
