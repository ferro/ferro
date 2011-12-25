window.l = (a) -> console.log a



class Session extends Backbone.Model

class SessionList extends Backbone.Collection
  model: Session
  localStorage: new Store 'sessions'

sessions = new SessionList

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

  delete: ->
    @model.destroy()
    $(@el).remove()

get_shortcut = ->
  s = localStorage.shortcut
  text = ''
  text += 'Shift-' if s.shift
  text += 'Ctrl-' if s.ctrl
  text += 'Alt-' if s.alt
  text +=
    if s.key.length is 1
      s.key
    else
      f.KEYS.NAMES[key] 
  
$ =>
  sessions.fetch()
  sessions.each (s) =>
    if s.attributes.id
      $('#session-list').append (new SessionView({model: s})).render().el 
  $('span')[0].focus()
  
  shortcut = $('input')[0]
  shortcut.value = get_shortcut()
  shortcut.keydown (e) =>
    key = String.fromCharCode e.keyCode
    if key is ''
      key = f.KEYS.CODES[e.keyCode]
    localStorage.shortcut =
      key: key
      alt: e.altKey
      ctrl: e.ctrlKey
      shift: e.shiftKey
    shortcut.value = get_shortcut
  
  # localStorage.clear()
  # sessions.add [
  #   {x: '1'}
  #   {x: '2'}
  #   {x: '3'}
  # ]
  # sessions.each (m) ->
  #    m.save()

