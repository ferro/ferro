js = document.createElement 'script'
js.src = chrome.extension.getURL 'js/content.js'
js.type = 'text/javascript'
document.getElementsByTagName('head')[0].appendChild js
