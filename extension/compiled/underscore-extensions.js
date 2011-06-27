(function() {
  var __slice = Array.prototype.slice;
  window._.copy = function() {
    var key, keys, o, ret, _i, _len;
    o = arguments[0], keys = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    ret = {};
    for (_i = 0, _len = keys.length; _i < _len; _i++) {
      key = keys[_i];
      ret[key] = o[key];
    }
    return ret;
  };
}).call(this);
