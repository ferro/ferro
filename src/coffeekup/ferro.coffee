bold_entered = (t) ->
  last = 0
  for c in @entered
    i = t.indexOf c
    text t[last..i-1] unless last is i
    b c
    last = i + 1

get_icon = (o, accept_array) ->
  switch f.get_type o
  when f.CONTEXTS.COMMAND #todo doesn't recognize f
    chrome.extension.getURL 'gear.png'
  when f.CONTEXTS.SPECIAL
    chrome.extension.getURL 'page.ico'
  when f.CONTEXTS.BOOKMARK
    'chrome://favicon/' + o.url
  when f.CONTEXTS.APP, f.CONTEXTS.EXTENSION
    icons = _.filter o.icons, (i) ->
      i.size is 16
    icons[0].url
  when f.CONTEXTS.TAB
    tab.favIconUrl
  when f.CONTEXTS.SESSION
    if accept_array
      o.wins.icons
    else
      chrome.extension.getURL 'pages.ico'
  else
    null

get_name = (o) ->
  o.name or o.title      

get_desc = (o) ->
  desc = main.cmd.desc or main.desc or main.description
  if main.url
    if main.url[0..6] is 'http://'
      desc = main.url[7..-1]
    else if main.url[0..7] is 'https://'
      desc = main.url[8..-1]
    else
      desc = main.url
  desc[0..39] if desc

div id: 'ferro', ->
  div id: 'f-box', ->
    visibility = if @text then 'visible' else 'hidden'
    textarea id: 'f-text', cols: '20', rows: '4', style: 'visibility: ' + visibility
    main_klass = ''
    cmd_klass = ''
    if @state is f.STATES.MAIN
      main_klass = 'f-selected'
      cmd_klass = ''
    else
      main_klass = ''
      cmd_klass = 'f-selected'
    div id: 'f-main', class: main_klass, ->
      sugs = @suggestions[f.STATES.MAIN]
      main = sugs.list[sugs.selection]
      icon = get_icon main
      if icon
        img id: 'f-icon-main', src: icon, width: 16px, height: 16px
      div id: 'f-name-main', ->
        bold_entered get_name main
      div id: 'f-description-main', get_desc main
    div id: 'f-cmd', class: cmd_klass, ->
      sugs = @suggestions[f.STATES.CMD]
      cmd = sugs.list[sugs.selection]
      div id: 'f-name-cmd', get_name cmd
      div id: 'f-description-cmd', cmd.cmd.desc
  div id: 'f-suggestions', ->
    div id: 'f-entered', ->
      span id: 'f-entered-text', 'entered'
    for i in [0..f.NUM_SUGGESTIONS-1]
      cur = @suggestions[@state].list[i]
      klass = 'f-suggest'
      klass += ' f-selected' if i is @suggestions[@state].selection
      div id: 'f-' + i, class: klass, ->
        icon = get_icon cur
        if icon
          img class: 'f-icon', src: icon, width: '16px', height: '16px'
        div class: 'f-title', get_name cur
        div class: 'f-url', get_desc cur
