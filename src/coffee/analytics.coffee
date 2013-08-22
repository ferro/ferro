unless _gaq
  _gaq = []
  _gaq.push ['_setAccount', 'UA-42896199-2']
  if chrome.extension
    # this prevents the tracking beacon being sent, maybe due to a check to see whether this is actually a subdomain
    # _gaq.push(['_setDomainName', 'getferro.com']);
    _gaq.push ['_setSessionCookieTimeout', 0]
    _gaq.push ['_setCustomVar', 2, 'saved sessions', 0, 1] #todo
    chrome.storage.sync.get 'donated', (data) ->
      _gaq.push ['_setCustomVar', 1, 'donated', data.donated, 1]
      _gaq.push ['_trackPageview']
  else 
    _gaq.push(['_setDomainName', 'getferro.com']);
    _gaq.push ['_trackPageview']

  ga = document.createElement('script')
  ga.type = 'text/javascript'
  ga.async = true
  ga.src = 'https://ssl.google-analytics.com/ga.js'
  s = document.getElementsByTagName('script')[0]
  s.parentNode.insertBefore(ga, s)
    