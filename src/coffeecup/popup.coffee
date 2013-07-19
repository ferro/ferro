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
  unless o
    return ''
  o.name or o.title or o.get('name')

helpers =
    icon: (attrs) ->
      attrs.width = attrs.height = '16px'
      img attrs
  
    description: (o) ->
      unless o
        return -> text ''

      if o.constructor.name is 'Session'
        ->
          for win in o.get('wins')
            for url in win.icons
              icon {src: url}
            span class: 'spacer'
      else
        desc = o?.cmd?.desc or o?.desc or o?.description
        if o?.url
          if o?.url[0..6] is 'http://'
            desc = o?.url[7..-1]
          else if o?.url[0..7] is 'https://'
            desc = o?.url[8..-1]
          else
            desc = o?.url
        -> text desc

popup_template = ->
  div id: 'ferro', ->
    div id: 'f-box', ->
      z @in_text_mode()
      z @text_mode_text
      visibility = if @in_text_mode() then 'visible' else 'hidden'
      z visibility
      textarea id: 'f-text', cols: '20', rows: '4', style: 'visibility: ' + visibility
      main_klass = ''
      cmd_klass = ''
      if @state is @STATES.CMD
        main_klass = ''
        cmd_klass = 'f-selected'
      else
        main_klass = 'f-selected'
        cmd_klass = ''
      div id: 'f-main', class: main_klass, ->
        sugs = @suggestions[@STATES?.MAIN]
#        if @text_entered
        main_selection = sugs.list[sugs.selection] 
        d 'text_entered, sugs, main_selection: '
        d @text_entered
        d sugs
        d main_selection
        url = get_icon main_selection
        if url
          icon {src: url, id: 'f-icon-main'}
        div id: 'f-name-main', ->
          if main_selection
            # text bold_entered get_name main_selection
            text get_name main_selection
          else
            text ''
        div id: 'f-description-main', description main_selection
      div id: 'f-cmd', class: cmd_klass, ->
        sugs = @suggestions[@STATES.CMD]
        cmd = sugs.list[sugs.selection]
        d 'AAAA sugs'
        d sugs
        d 'popup cmd'
        d cmd
        div id: 'f-name-cmd', ->
          text get_name(cmd) or ''
        div id: 'f-description-cmd', description cmd
    div id: 'f-suggestions', ->
      div id: 'f-entered', ->
        span id: 'f-entered-text', ->
          text @text_entered
      console.log @suggestions
      if @state isnt @STATES.TEXT and @suggestions[@state].selection isnt null
        size = Math.min(@suggestions[@state].list.length, @NUM_SUGGESTIONS)
        for i in [0...size]
          cur = @suggestions[@state]?.list[i]
          klass = 'f-suggest'
          klass += ' f-selected' if i is @suggestions[@state].selection
          div id: 'f-' + i, class: klass, ->
            url = get_icon cur
            if url
              icon {src: url, class: 'f-icon'}
            div class: 'f-title', ->
              # console.log 'cur: '
              # console.log cur
              # console.log(get_name cur)
              text get_name cur
            div class: 'f-url', description cur


