window.l = (a) -> console.log a


# key = String.fromCharCode e.keyCode
# if key is ''
#   key = f.KEYS.CODES[e.keyCode]
# shortcut =
#   key: key
#   alt: e.altKey
#   ctrl: e.ctrlKey
#   shift: e.shiftKey

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

$ ->
  sessions.fetch()
  sessions.each (m) ->
    if m.attributes.id
      $('#session-list').append (new SessionView({model: m})).render().el 
  $('span')[0].focus()


  
  # localStorage.clear()
  # sessions.add [
  #   {x: '1'}
  #   {x: '2'}
  #   {x: '3'}
  # ]
  # sessions.each (m) ->
  #    m.save()

