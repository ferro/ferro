t = text

doctype 5
html ->
  head ->
    title 'Ferro'
    meta charset: 'utf-8'
    link
      href: 'css/options.css'
      media: 'all'
      rel: 'stylesheet'
      type: 'text/css'
    script src: 'js/options.js'
  body ->
    aside '#banner', ->
      a href: 'https://github.com/ferro/ferro/', -> 'Fork me on GitHub'
    tag 'main', ->
      h1 'Ferro'
      p ->
        t 'Ferro provides session management and a keyboard interface to Chrome. It functions similarly to application launchers like Quicksilver. Hit '
        code 'Alt-Shift-F'
        t ', type, (optionally hit '
        code 'tab'
        t 'and type again) and hit '
        code 'enter'
        t '. For a complete usage guide, visit '
        a href: 'http://www.getferro.com', -> 'getferro.com'
        t '.'
      h3 'Saved Sessions'
      ul id: 'session-list'
      h3 'Keyboard Shortcuts'
      p ->
        t 'To set up keyboard shortcuts, go to the extensions page ('
        code 'chrome://extensions'
        t ') and click the &ldquo;Configure commands&rdquo; link on the bottom right.'
      span '#prefix', ->
        code 'Alt-Shift-'
      table '.keys', ->
        tr ->
          th 'Recommended Shortcut'
          th 'Command'
        tr ->
          td ->
            code 'F'
          td 'Activate the extension'
        tr ->
          td ->
            code 'D'
          td 'Duplicate tab'
        tr ->
          td ->
            code 'R'
          td 'Repeat the last command'
        tr ->
          td ->
            code 'P'
          td 'Toggle tab pin'
      h3 'Commands'
      table '.commands', ->
        tr ->
          th 'Name'
          th 'Description'
        sorted_commands = Object.keys(COMMANDS).sort()
        for i in [0...sorted_commands.length]
          name = sorted_commands[i]
          cmd = COMMANDS[name]
          tr ->
            td sentence_case name
            td cmd.desc
      h3 'Recommended Extensions'
      ul '#recommendations', ->
      	li ->
      	  a href: 'https://chrome.google.com/webstore/detail/dbepggeogbaibhgnhhndojpepiihcmeb', -> 'Vimium'
      	  ': Provides better keyboard navigation. You can even customize the shortcuts to better match the one true editor.'
      	li ->
      	  a href: 'https://chrome.google.com/webstore/detail/gijmaphaippejlhagngohjmehmanbehd', -> 'QuickShift'
      	  ': Move tabs to a different window or to a new location within the current window using your keyboard.'
      	li ->
      	  a href: 'https://chrome.google.com/webstore/detail/hdokiejnpimakedhajhdlcegeplioahd', -> 'Lastpass'
      	  ': Automatically generate, remember, and fill in passwords.'
        li ->
          a href: 'http://defunkt.io/dotjs/', -> 'Dotjs'
          ': Modify websites yourself with Javascript. Better than Greasemonkey. Requires OS X.'
      footer ->
        a href: 'http://www.getferro.com', -> 'getferro.com'
        t '&#167'
        a href: 'https://github.com/ferro/ferro/issues', -> 'problems & suggestions'
    aside '#donate', ->
      img src: 'images/panang.jpg', height: '120', width: '120'
      label 'Chicken Panang Curry (พะแนงไก่) is $9.95'
      h2 'Create happiness'
      p '#feeding', 'I emphatically adore Thai vittles. Your donation will endow my occasional excursions to the local Thai restaurant and thereupon deliver felicity to my life. Donating will also expunge the photograph, which has perchance oft engendered thine appetite.'
      ul '#form', ->
        li ->
          label 'Donor name:'
          input id: 'name', type: 'text', value: 'Anonymous', tabindex: '100'
        li ->
          label 'Amount:'
          input id: 'amount', type: 'number', value: '9.95', tabindex: '101'
      div '.header', 'Amount lost to processing fees:'
      ul '#options', ->
        li ->
          span '.stripe', '$ 0.59'
          button '#stripe.action', 'Use credit card', tabindex: '102'
        li ->
          span '.bitcoin', '$ 0.00'
          button '#bitcoin.action', 'Use bitcoins', tabindex: '103'
      p '#list', 'Most recent donations: '
      table id: 'donations', ->
        tr ->
          td ''
          td ''
          td ''
        tr ->
          td ''
          td ''
          td ''
        tr ->
          td ''
          td ''
          td ''
        tr ->
          td ''
          td ''
          td ''
        tr ->
          td ''
          td ''
          td ''
      a href: 'http://donate.getferro.com', tabindex: '104', -> 'Complete donor table'
      div '.coinbase-button', ''
