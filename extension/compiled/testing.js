(function() {
  var contentPort, port;
  window.log = function(x) {
    return console.log(x);
  };
  contentPort = {};
  port = {
    onMessage: {
      addListener: function(fn) {
        return port.fn = fn;
      }
    },
    postMessage: function(msg) {
      return contentPort.fn(msg);
    }
  };
  contentPort = {
    onMessage: {
      addListener: function(fn) {
        return contentPort.fn = fn;
      }
    },
    postMessage: function(msg) {
      return port.fn(msg);
    }
  };
  window.chrome = {
    extension: {
      connect: function() {
        return contentPort;
      },
      onConnect: {
        addListener: function(fn) {
          return fn(port);
        }
      }
    }
  };
}).call(this);
