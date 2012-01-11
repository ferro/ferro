window.l = (a) -> console.log a

class SessionView extends Backbone.View

  tagName: 'li'

  events:
    'click .delete': 'delete'
    keyup: 'edited'
    paste: 'edited'

  initialize: ->
    @model.view = @

  edited: ->
     if @model.get('x') isnt @el.firstChild.innerText
       @save()

  save: ->
    @model.save x: @el.firstChild.innerText, silent: true

  render: =>
    $(@el).html '<span contenteditable=true>' + @model.get('x') + '</span> <button class="delete">Delete</button>'
    @
#<img src="chrome://favicon/http://www.google.com/">
  # 
  delete: ->
    @model.destroy()
    $(@el).remove()

get_shortcut = (s) ->
  text = ''
  text += 'Shift-' if s.shift
  text += 'Ctrl-' if s.ctrl
  text += 'Alt-' if s.alt
  text += if s.key.length is 1 then s.key else f.KEYS.NAMES[s.key] 
  
$ =>
  sessions.fetch()
  sessions.each (s) =>
    if s.attributes.id
      $('#session-list').append (new SessionView({model: s})).render().el 

  if sessions.size is 0
    $('#session-list').before '<i>None</i>'

  if $('span')[0]
    $('span')[0].focus()
    
  shortcut = $('input')
  shortcut.val get_shortcut(JSON.parse localStorage.shortcut)
  shortcut.keydown (e) =>
    return if e.keyCode is 9 #tab

    if f.KEYS.NAMES[e.keyCode]
      key = e.keyCode
    else
      key = String.fromCharCode e.keyCode
      return if not key or key is ''
    new_shortcut = 
      key: key
      alt: e.altKey
      ctrl: e.ctrlKey
      shift: e.shiftKey
    localStorage.shortcut = JSON.stringify new_shortcut
    chrome.extension.sendRequest
      action: 'update_shortcut'
    if e.altKey or e.ctrlKey or e.shiftKey or key is e.keyCode
      shortcut.val get_shortcut new_shortcut
    else 
      shortcut.val ''
  
  # localStorage.clear()
  # sessions.add [
  #   {x: '1'}
  #   {x: '2'}
  #   {x: '3'}
  # ]
  # sessions.each (m) ->
  #    m.save()

