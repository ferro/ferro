sentence_case = (s) ->
  ret = s[0].toUpperCase() + s[1..-1]
  if (i = s.indexOf '_') > 0
    ret = ret[0..i-1] + ' ' + s[i+1].toUpperCase() + s[i+2..-1]
  ret

reverse = (h) ->
  o = {}
  o[v] = sentence_case k for k, v of h
  o

f.keys =
  codes:
    return: 13
    esc: 27
    space: 32
    page_up: 33
    page_down: 34
    end: 35
    home: 36
    left: 37
    up: 38
    right: 39
    down: 40

f.keys.names = reverse f.keys.codes

