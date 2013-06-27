bold_entered = (to_bold) ->
  @text_entered = @text_entered.toLowerCase()
  to_bold_lower = to_bold.toLowerCase()
  emboldened = ''
  last = 0
  for c in @text_entered
    i = to_bold_lower[last..].indexOf c
    if i is -1
      return emboldened + to_bold[last..]
    else
      if i isnt 0
        emboldened += to_bold[last...last+i]
      emboldened += '<b>' + to_bold[last+i] + '</b>'
      last += i + 1
      if last is to_bold.length
        return emboldened
  return emboldened + to_bold[last..]

get_icon = (o, accept_array = false) ->
  return null unless o
  switch @get_type o
    when @CONTEXTS.COMMAND 
      @gear_icon      
    when @CONTEXTS.SPECIAL
      @page_icon
    when @CONTEXTS.BOOKMARK
      # this only goes through your local browser cache
      # 'chrome://favicon/' + o.url
  
      'https://plus.google.com/_/favicon?domain=' + o.url
    when @CONTEXTS.APP, @CONTEXTS.EXTENSION
      icons = @filter o.icons, (i) ->
        i.size is 16
      if icons[0]
        icons[0].url
      else
        'chrome://theme/IDR_EXTENSIONS_FAVICON@2x'
    when @CONTEXTS.TAB
      o.favIconUrl
    when @CONTEXTS.SESSION
      if accept_array #todo 
        o.wins.icons
      else
        @pages_icon
    else
      null

get_name = (o) ->
  o?.name or o?.title      

get_desc = (o) ->
  desc = o?.cmd?.desc or o?.desc or o?.description
  if o?.url
    if o?.url[0..6] is 'http://'
      desc = o?.url[7..-1]
    else if o?.url[0..7] is 'https://'
      desc = o?.url[8..-1]
    else
      desc = o?.url
#  desc[0..39] if desc
  desc

popup_template = ->
  div id: 'ferro', ->
    div id: 'f-box', ->
      visibility = if @text_mode_text then 'visible' else 'hidden'
      textarea id: 'f-text', cols: '20', rows: '4', style: 'visibility: ' + visibility
      main_klass = ''
      cmd_klass = ''
      if @state is @STATES?.MAIN
        main_klass = 'f-selected'
        cmd_klass = ''
      else
        main_klass = ''
        cmd_klass = 'f-selected'
      div id: 'f-main', class: main_klass, ->
        sugs = @suggestions[@STATES?.MAIN]
#        if @text_entered
        main = sugs.list[sugs.selection] 
        d 'text_entered, sugs, main: '
        d @text_entered
        d sugs
        d main
        icon = get_icon main
        if icon
          img id: 'f-icon-main', src: icon, width: '16px', height: '16px'
        div id: 'f-name-main', ->
          if main
            n = get_name main
            text bold_entered n
          else
            text ''
        div id: 'f-description-main', ->
          text get_desc main if main
      div id: 'f-cmd', class: cmd_klass, ->
        sugs = @suggestions[@STATES.CMD]
        cmd = sugs.list[sugs.selection]
        d 'AAAA sugs'
        d sugs
        d 'cmd'
        d cmd
        div id: 'f-name-cmd', ->
          text get_name(cmd) or ''
        div id: 'f-description-cmd', ->
          text get_desc(cmd) or ''
    div id: 'f-suggestions', ->
      div id: 'f-entered', ->
        span id: 'f-entered-text', ->
          text @text_entered
      if @suggestions[@state].selection isnt null
        size = Math.min(@suggestions[@state].list.length, @NUM_SUGGESTIONS)
        for i in [0...size]
          cur = @suggestions[@state]?.list[i]
          klass = 'f-suggest'
          klass += ' f-selected' if i is @suggestions[@state].selection
          div id: 'f-' + i, class: klass, ->
            icon = get_icon cur
            if icon
              img class: 'f-icon', src: icon, width: '16px', height: '16px'
            div class: 'f-title', ->
              console.log 'cur: '
              console.log cur
              console.log(get_name cur)
              text get_name cur
            div class: 'f-url', ->
              console.log(get_desc cur)
              text get_desc cur



