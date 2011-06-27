doctype 5
html ->
  head ->
    title 'Ferro - Chrome Extension'
    link
      href: 'compiled/options.css'
      media: 'all'
      rel: 'stylesheet'
      type: 'text/css'
    script src: 'vendor/json2.js'
    script src: 'vendor/jquery-1.6.1.min.js'
    script src: 'vendor/underscore-min.js'
    script src: 'vendor/underscore.string.min.js'
    script src: 'vendor/backbone.js'
    script src: 'vendor/backbone-localstorage.js'
    script src: 'compiled/init.js'
    script src: 'compiled/testing.js'
    script src: 'compiled/app.js'
    script src: 'compiled/commands.js'
    script src: 'compiled/chrome-pages.js'
    script src: 'compiled/keys.js'
    script src: 'compiled/content-script.js'
    script src: 'compiled/logic.js'
  body ->
    ul id: 'session-list', ->
      li
