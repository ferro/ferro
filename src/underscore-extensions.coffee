window._.copy = (o, keys...) ->
  ret = {}
  for key in keys
    ret[key] = o[key]
  ret
