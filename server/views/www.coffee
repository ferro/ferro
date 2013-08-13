link rel: 'icon', type: 'image/png', href: 'favicon.gif'

aside '#banner', ->
  a href: 'https://github.com/ferro/ferro/', -> 'Fork me on GitHub'

aside '#install', ->
  form action: 'https://chrome.google.com/webstore/', method: 'get', ->
    button 'Install'
  label 'Install extension on the Chrome Web Store'

tag 'main', ->
  

footer ->
  a href: 'http://donate.getferro.com', -> 'donate'
  text '&#167'
  a href: 'https://github.com/ferro/ferro/issues', -> 'problems & suggestions'
