window.f or= {}

reverse = (h) ->
  o = {}
  o[v] = sentence_case k for k, v of h
  o

f.KEYS =
  CODES:
    RETURN: 13
    ESC: 27
    SPACE: 32
    PAGE_UP: 33
    PAGE_DOWN: 34
    END: 35
    HOME: 36
    LEFT: 37
    UP: 38
    RIGHT: 39
    DOWN: 40



f.KEYS.NAMES = reverse f.KEYS.CODES

