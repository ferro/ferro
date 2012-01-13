t = text

bold_entered = (to_bold) ->
  last = 0
  for c in @entered
    i = to_bold.indexOf c
    t to_bold[last..i-1] unless last is i
    b c
    last = i + 1

get_icon = (o, accept_array = false) ->
  switch ferro.get_type o
    when ferro.CONTEXTS.COMMAND 
      chrome.extension.getURL 'images/gear.png'
    when ferro.CONTEXTS.SPECIAL
      chrome.extension.getURL 'images/page.ico'
    when ferro.CONTEXTS.BOOKMARK
      'chrome://favicon/' + o.url
    when ferro.CONTEXTS.APP, ferro.CONTEXTS.EXTENSION
      icons = _.filter o.icons, (i) ->
        i.size is 16
      icons[0].url
    when ferro.CONTEXTS.TAB
      tab.favIconUrl
    when ferro.CONTEXTS.SESSION
      if accept_array #todo 
        o.wins.icons
      else
        chrome.extension.getURL 'images/pages.ico'
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
    if @state is ferro.STATES.MAIN
      main_klass = 'f-selected'
      cmd_klass = ''
    else
      main_klass = ''
      cmd_klass = 'f-selected'
    div id: 'f-main', class: main_klass, ->
      sugs = @suggestions[ferro.STATES.MAIN]
      main = sugs.list[sugs.selection]
      icon = get_icon main
      if icon
        img id: 'f-icon-main', src: icon, width: '16px', height: '16px'
      div id: 'f-name-main', ->
        bold_entered get_name main
      div id: 'f-description-main', ->
        t get_desc main
    div id: 'f-cmd', class: cmd_klass, ->
      sugs = @suggestions[ferro.STATES.CMD]
      cmd = sugs.list[sugs.selection]
      div id: 'f-name-cmd', ->
        t get_name cmd
      div id: 'f-description-cmd', ->
        t cmd.cmd.desc
  div id: 'f-suggestions', ->
    div id: 'f-entered', ->
      span id: 'f-entered-text', 'entered'
    for i in [0..ferro.NUM_SUGGESTIONS-1]
      cur = @suggestions[@state].list[i]
      klass = 'f-suggest'
      klass += ' f-selected' if i is @suggestions[@state].selection
      div id: 'f-' + i, class: klass, ->
        icon = get_icon cur
        if icon
          img class: 'f-icon', src: icon, width: '16px', height: '16px'
        div class: 'f-title', ->
          t get_name cur
        div class: 'f-url', ->
          t get_desc cur
