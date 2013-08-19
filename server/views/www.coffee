link rel: 'icon', type: 'image/png', href: 'favicon.gif'

aside '#banner', ->
  a href: 'https://github.com/ferro/ferro/', -> 'Fork me on GitHub'

aside '#install', ->
  form action: 'https://chrome.google.com/webstore/', method: 'get', ->
    button 'Install'
  label 'Install extension on the Chrome Web Store'

tag 'main', ->
  h1 'Ferro'
  p 'Ferro is an extension to the Google Chrome browser that provides the following functionality:'
  ul '.spaced', ->
    li ->
      b 'Session management:'
      text " Save your current tabs and open them later. You may use this for instance if you are working on a research project and have many web pages open in different tabs or windows, and you would like to close them for a while but be able to reopen them later. Saved sessions are synced with all computers that you have signed on in Chrome with your Google account. (See the “Sign in” section of Chrome's settings.)"
    li ->
      b 'Keyboard access to Chrome commands:'
      text ' Any Chrome command for which there is not already a keyboard shortcut can be quickly run, such as pinning a tab or opening a bookmark.'


  h3 'Usage'
  p ->
    text 'Press '
    code 'Alt-Shift-F'
    text ' to open Ferro'
  img src: 'blank.png'

  p 'Start typing and suggestions will be displayed. Suggestions are drawn from:'
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
  img src: 'suggestions.png'
  label ->
    text 'After typing '
    code 'TODO'

  p ->
    text 'Change your selection using the ▼ or ▲ arrows or '  
    code 'Ctrl-N/P'
    text ' on a Mac.'
  img src: 'selection.png'
  label 'Fourth suggestion is selected.'

  p 'The default command will be displayed in the right section. Sessions will be reopened, open tabs will be selected, and bookmarks, history items, apps, extension options pages, and special pages will be opened in a new tab.'
  img src: 'default.png'
  label 'Default command for __ is __'

  p ->
    text 'To change the command, use '
    code 'tab' 
    text ' or the ▶ arrow to select the right section. Then start typing the name of the command or use the ▼ or ▲ arrows.'
  img src: 'command-choice.png'
  label ->
    text 'After typing '
    code '__'

  p ->
    text 'When you have completed making your selection, press the '
    code 'enter'
    text ' key.'

  p ->
    text 'To close Ferro without making a selection, press the '
    code 'esc'
    text ' key.'

  p 'If you select a command in the left section, nothing is needed in the right section. Examples of commands that can appear in the left section are “Pin”, which will pin the current tab, and “Reload All Tabs.”'
  img src: 'pin.png'

  p 'Some commands, such as “Speak” or “Search History,” require you to enter text in the left section. To begin entering text, press period. Then type the text and continue as normal. For more such commands, see those in the full command list below that call for “given text” or “name given”.'
  img src: 'text.png'
  label ->
    text 'After typing '
    code '.__'

section ->
  h3 'Sessions'

  p ->
    text 'Saving a session is another example of needing to enter text in the left section. Press period, then type the name you would like to give the new session. Press '
    code 'tab'
    text ', type “save”, and select either the “Save” command, which saves all the tabs in your current window, or the “Save All” command, which saves all open windows. Finally, press the '
    code 'enter'
    text ' key.'
  img src: 'session.png'

  p 'Saved sessions can be viewed on the Ferro options page.'
  img src: 'options.png'

  p 'Sessions can be opened or deleted by typing the name of the session in the Ferro popup.'
  img src: 'delete.png'

section ->
  h3 'The Name'
  p "Ferro is named after iron. Iron and chromium are joined to form the alloy ferrochrome, a constituent of steel (it prevents corrosion and increases hardness). Iron is also pretty exquisite on its own. It is the center of the protein that transports oxygen around our bodies, it is the most common element inside our planet, and it is the largest element the Sun can create until it becomes a red giant in ~5.4 billion years. (And then it can only make up to Bismuth. It takes a much larger star to make larger elements, and then only when it explodes.) Thank you China for mining the majority of today's iron ore."


#modified from options.coffee
section ->
  h3 'Available Commands'
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
