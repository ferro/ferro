# key = String.fromCharCode e.keyCode
# if key is ''
#   key = f.KEYS.CODES[e.keyCode]
# shortcut =
#   key: key
#   alt: e.altKey
#   ctrl: e.ctrlKey
#   shift: e.shiftKey

$ ->

  class Session extends Backbone.Model

  class SessionList extends Backbone.Collection

    model: Session

    localStorage: new Store 'sessions'

  window.sessions = new SessionList

  class SessionView extends Backbone.View

    tagName: 'li'

    events:
      'click .delete' : 'delete'

    initialize: ->
      @model.bind 'change', @render
      @model.view = @

    render: =>
      @$(@el).html 'test' + @model.get('x')
      @

    delete: ->
      @model.destroy()
      $(@el).remove()

  sessions.fetch()

  # sessions.each (m) ->
  #   m.destroy()

  # sessions.add [
  #   {x: 1}
  #   {x: 2}
  # ]

  # sessions.each (m) ->
  #   m.save()

  sessions.each (m) ->
    $('#session-list').append (new SessionView({model: m})).render().el
  # sessions.each (m) ->
  #   $('#session-list').append (new SessionView({model: m})).render().el

  # sessions.each (m) ->
  #   $('#session-list').append (new SessionView({model: m})).render().el
