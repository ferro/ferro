link rel: 'icon', type: 'image/png', href: 'favicon.gif'

aside '#banner', ->
  a href: 'https://github.com/ferro/ferro/', -> 'Fork me on GitHub'

aside '#install', ->
  form action: 'https://chrome.google.com/webstore/', method: 'get', ->
    button 'Install'
  label 'Install extension on the Chrome Web Store'

tag 'main', ->
  p 'Ferro is an extension to the Google Chrome browser that provides the following functionality:'
  ul ->
    li 'Session management: Save your current tabs and open them later. For instance if you are working on a research project and have many web pages open in different tabs or windows, and you would like to close them for a while but be able to reopen them later.'
    li 'Chrome commands: Any Chrome command for which there is not already a keyboard shortcut can be quickly run, such as pinning a tab or opening a bookmark.'


  p ->
    text 'Press the '
    code 'Esc'
    text ' key to close the popup.'
footer ->
  a href: 'http://donate.getferro.com', -> 'donate'
  text '&#167'
  a href: 'https://github.com/ferro/ferro/issues', -> 'problems & suggestions'
