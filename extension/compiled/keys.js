(function() {
  var reverse, sentence_case;
  sentence_case = function(s) {
    var i, ret;
    ret = s[0].toUpperCase() + s.slice(1);
    if ((i = s.indexOf('_')) > 0) {
      ret = ret.slice(0, (i - 1 + 1) || 9e9) + ' ' + s[i + 1].toUpperCase() + s.slice(i + 2);
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
  f.keys = {
    codes: {
      "return": 13,
      esc: 27,
      space: 32,
      page_up: 33,
      page_down: 34,
      end: 35,
      home: 36,
      left: 37,
      up: 38,
      right: 39,
      down: 40
    }
  };
  f.keys.names = reverse(f.keys.codes);
}).call(this);
