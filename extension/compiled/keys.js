(function() {
  var reverse, sentence_case;
  sentence_case = function(s) {
    var i, ret;
    ret = s[0].toUpperCase() + s.slice(1).toLowerCase();
    if ((i = s.indexOf('_')) > 0) {
      return ret.slice(0, (i - 1 + 1) || 9e9) + ' ' + s[i + 1].toUpperCase() + s.slice(i + 2).toLowerCase();
    }
    return ret;
  };
  reverse = function(h) {
    var k, o, v;
    o = {};
    for (k in h) {
      v = h[k];
      o[v] = sentence_case(k);
    }
    return o;
  };
  f.KEYS = {
    CODES: {
      RETURN: 13,
      ESC: 27,
      SPACE: 32,
      PAGE_UP: 33,
      PAGE_DOWN: 34,
      END: 35,
      HOME: 36,
      LEFT: 37,
      UP: 38,
      RIGHT: 39,
      DOWN: 40
    }
  };
  f.KEYS.NAMES = reverse(f.KEYS.CODES);
}).call(this);
