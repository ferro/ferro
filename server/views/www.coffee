link rel: 'icon', type: 'image/png', href: 'favicon.gif'

aside '#banner', ->
  a href: 'https://github.com/ferro/ferro/', -> 'Fork me on GitHub'

aside '.left', ->
  div '#install', ->
    form action: 'https://chrome.google.com/webstore/detail/ferro/pioihedddcnmkeeeomkcfppglpehegfh/', method: 'get', ->
      button '.action', 'Install Ferro'
    label 'Install extension on the Chrome Web Store'

  nav ->
    h4 ->
      a href: '#', 'Ferro'
    ul ->
      li ->
        a href: '#usage', 'Usage'
      li ->
        a href: '#sessions', 'Sessions'
      li ->
        a href: '#name', 'The Name'
      li ->
        a href: '#commands', 'Available Commands'

tag 'main', ->
  h1 'Ferro'
  p ->
    text 'Ferro is a Google Chrome extension that is similar to application launchers like Quicksilver, Launchy, and Do. Using only your keyboard, you can quickly open pages in your history or bookmarks, open apps or extension pages, and save your current tabs for opening later (see '
    a href: '#sessions', -> 'sessions section'
    text ' below). You can also perform other commands, such as deleting a bookmark, disabling an extension, and pinning a tab. For more commands, see the full '
    a href: '#commands', -> 'command list'
    text '.'
  


  h3 '#usage', 'Usage'

  a class: 'fancybox-thumb', rel: 'group', href: 'images/blank.png', title: 'Initial popup', ->
    img src: 'images/blank.png'
  label ''
  p ->
    text 'Press '
    code 'Alt-Shift-F'
    text ' to open Ferro'

  div '.instruction', ''

  a class: 'fancybox-thumb', rel: 'group', href: 'images/suggestions.png', title: 'After typing e', ->
    img src: 'images/suggestions.png'
  label ->
    text 'After typing '
    code 'e'
  p ->
    text 'Start typing and suggestions will be displayed. Suggestions are drawn from:'
  ul ->
    li 'Saved sessions'
    li 'Open tabs'
    li 'Bookmarks'
    li 'History'
    li 'Installed apps and extensions'
    li 'Ferro commands'
    li ->
      text 'Chrome special pages (listed on '
      code 'chrome://about'
      text ').'

  div '.instruction', ''

  a class: 'fancybox-thumb', rel: 'group', href: 'images/selection.png', title: 'Third suggestion is selected', ->
    img src: 'images/selection.png'
  label 'Third suggestion is selected.'
  p ->
    text 'Change your selection using the ▼ or ▲ arrows or '  
    code 'Ctrl-N/P'
    text ' on a Mac.'

  div '.instruction', ''
    
  a class: 'fancybox-thumb', rel: 'group', href: 'images/default.png', title: 'Default command for an extension is to open the options page.', ->
    img src: 'images/default.png'
  label 'Default command for an extension is to open the options page.'
  p 'The default command will be displayed in the right section. Sessions will be reopened, open tabs will be selected, and bookmarks, history items, apps, extension options pages, and special pages will be opened in a new tab.'

  div '.instruction', ''

  a class: 'fancybox-thumb', rel: 'group', href: 'images/command-choice.png', title: 'After typing tab followed by d', ->
    img src: 'images/command-choice.png'
  label ->
    text 'After typing '
    code 'tab'
    text ' followed by '
    code 'd'
  p ->
    text 'To change the command, use '
    code 'tab' 
    text ' or the ▶ arrow to select the right section. Then start typing the name of the command or use the ▼ or ▲ arrows.'

  div '.instruction', ''

  p ->
    text 'When you have completed making your selection, press the '
    code 'enter'
    text ' key.'

  p ->
    text 'To close Ferro without making a selection, press the '
    code 'esc'
    text ' key.'

  a class: 'fancybox-thumb', rel: 'group', href: 'images/pin.png', title: 'Pin command', ->
    img src: 'images/pin.png'
  label ''
  p 'If you select a command in the left section, nothing is needed in the right section. Examples of commands that can appear in the left section are “Pin”, which will pin the current tab, and “Reload All Tabs.”'

  div '.instruction', ''

  a class: 'fancybox-thumb', rel: 'group', href: 'images/text.png', title: 'After typing .elon', ->
    img src: 'images/text.png'
  label ->
    text 'After typing '
    code '.elon'
  p 'Some commands, such as “Speak” or “Search History,” require you to enter text in the left section. To begin entering text, press period. Then type the text and continue as normal. For more such commands, see those in the full command list below that call for “given text” or “name given”.'

  div '.instruction', ''

section ->
  h3 '#sessions', 'Session Management'

  text "You can save your session - current set of open tabs - and open it later. You may use this for instance if you are working on a research project and have many web pages open in different tabs or windows, and you would like to close them for a while but be able to reopen them later. Saved sessions are synced with all computers that you have signed on in Chrome with your Google account. (See the “Sign in” section of Chrome's settings.)"
  
  a class: 'fancybox-thumb', rel: 'group', href: 'images/session.png', title: 'Saving a session', ->
    img src: 'images/session.png'
  label ''
  p ->
    text 'Saving a session is another example of needing to enter text in the left section. Press period, then type the name you would like to give the new session. Press '
    code 'tab'
    text ', type “save”, and select either the “Save” command, which saves all the tabs in your current window, or the “Save All” command, which saves all open windows. Finally, press the '
    code 'enter'
    text ' key.'

  div '.instruction', ''

  a class: 'fancybox-thumb', rel: 'group', href: 'images/options.png', title: 'Ferro options page', ->
    img src: 'images/options.png'
  p 'Saved sessions can be viewed on the Ferro options page.'

  div '.instruction', ''

  a class: 'fancybox-thumb', rel: 'group', href: 'images/open.png', title: 'Opening a session', ->
    img src: 'images/open.png'
  p 'Sessions can be opened or deleted by typing the name of the session in the Ferro popup.'

  div '.instruction', ''

section ->
  h3 '#name', 'The Name'
  p "Ferro is named after iron. Iron and chromium are joined to form the alloy ferrochrome, a constituent of steel (it prevents corrosion and increases hardness). Iron is also pretty exquisite on its own. It is the center of the protein that transports oxygen around our bodies, it is the most common element inside our planet, and it is the largest element the Sun can create until it becomes a red giant in ~5.4 billion years. (And then it can only make up to Bismuth. It takes a much larger star to make larger elements, and then only when it explodes.) Thank you China for mining the majority of today's iron ore."


#modified from options.coffee
section ->
  h3 '#commands', 'Available Commands'
  table ->
    tr ->
      th 'Name'
      th 'Description'
    sorted_commands = Object.keys(@COMMANDS).sort()
    for i in [0...sorted_commands.length]
      name = sorted_commands[i]
      cmd = @COMMANDS[name]
      tr ->
        td @sentence_case name
        td cmd.desc


footer ->
  a href: 'http://donate.getferro.com', -> 'donate'
  text '&#167'
  a href: 'https://github.com/ferro/ferro/issues', -> 'problems & suggestions'
