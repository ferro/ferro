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
  body ->
    aside '#banner', ->
      a href: 'https://github.com/ferro/ferro/', -> 'Fork me on GitHub'
    aside '#donate', ->
      h3 'Feed me'
      img src: 'images/panang.jpg', height: '120', width: '120'
      p 'I emphatically adore Thai vittles. Your donation will endow my occasional excursions to the local Thai restaurant and thereupon deliver felicity to my life. It will also get rid of this box, which has probably been making you hungry.'
      label 'Donor name:'
      input id: 'name', type: 'text', placeholder: 'Anonymous'
      label 'Amount:'
      span '.currency', ->
        text '$'
        input id: 'amount', type: 'number', placeholder: '9.95'
      span '.note', 'Chicken Panang Curry (พะแนง) is $9.95'
      span '.header', 'Amount left after processing fees'
      input '#stripe', type: 'button', 'Use credit card'
      span 
      input '#bitcoin', type: 'button', 'Use bitcoins'
      span
      p 'Most recent donations: '
      ul '#donations'
      a href: 'http://donate.getferro.com', -> 'Full list of donors'
    section '#main', ->
      h1 'Ferro'
      p ->
        t 'Ferro provides session management and a keyboard interface to Chrome. It functions similarly to application launchers like Quicksilver. Hit '
        code 'Alt-Shift-F'
        t ', type, (optionally hit '
        code 'tab'
        t 'and type again) and hit '
        code 'enter'
        t '. For more information on usage, visit '
        a href: 'http://getferro.com', -> 'getferro.com'
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
          ': Modify websites yourself with Javascript. Better than Greasemonkey.'
      footer ->
        a href: 'http://getferro.com', -> 'getferro.com'
        t '&#167'
        a href: 'https://github.com/ferro/ferro/issues', -> 'problems & suggestions'
