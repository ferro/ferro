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
    script src: 'https://checkout.stripe.com/v2/checkout.js'
    script src: 'https://coinbase.com/assets/button.js'
  body ->
    aside '#banner', ->
      a href: 'https://github.com/ferro/ferro/', -> 'Fork me on GitHub'
    aside '#donate', ->
      img src: 'images/panang.jpg', height: '120', width: '120'
      label 'Chicken Panang Curry (พะแนง) is $9.95'
      h2 'Feed me?'
      p '#feeding', 'I emphatically adore Thai vittles. Your donation will endow my occasional excursions to the local Thai restaurant and thereupon deliver felicity to my life. Donating will also expunge the photograph, which has perchance oft engendered thine appetite.'
      ul '#form', ->
        li ->
          label 'Donor name:'
          input id: 'name', type: 'text', value: 'Anonymous', tabindex: '100'
        li ->
          label 'Amount:'
          input id: 'amount', type: 'number', value: '9.95', tabindex: '101'
      div '.header', 'Amount left after processing fees:'
      ul '#options', ->
        li ->
          span '.stripe', '$ 9.36'
          button '#stripe', 'Use credit card', tabindex: '102'
        li ->
          span '.bitcoin', '$ 9.95'
          button '#bitcoin', 'Use bitcoins', tabindex: '103'
      p '#list', 'Most recent donations: '
      ul id: 'donations'
      a href: 'http://donate.getferro.com', tabindex: '104', -> 'Complete donor table'
      div '.coinbase-button', ''
    tag 'main', ->
      h1 'Ferro'
      p ->
        t 'Ferro provides session management and a keyboard interface to Chrome. It functions similarly to application launchers like Quicksilver. Hit '
        code 'Alt-Shift-F'
        t ', type, (optionally hit '
        code 'tab'
        t 'and type again) and hit '
        code 'enter'
        t '. For more information on usage, visit '
        a href: 'http://www.getferro.com', -> 'getferro.com'
        t '.'
      h3 'Saved Sessions'
      ul id: 'session-list'
      p ->
        t 'Sessions are only saved locally to this computer. When Chrome provides a method of syncing extension data to your other computers, I will implement synced sessions.'
      h3 'Keyboard Shortcuts'
      p ->
        t 'To set up keyboard shortcuts, go to the extensions page ('
        code 'chrome://extensions'
        t ') and click the "Configure commands" link on the bottom right.'
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
      h3 'Available Commands'
      table ->
        tr ->
          th 'Name'
          th 'Description'
        sorted_commands = Object.keys(COMMANDS).sort()
        for i in [0...sorted_commands.length]
          name = sorted_commands[i]
          console.log "HWEJ"
          cmd = COMMANDS[name]
          tr ->
            td sentence_case name
            td cmd.desc
      h3 'Recommended Extensions'
      ul ->
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
