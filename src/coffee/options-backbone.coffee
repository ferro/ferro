window.l = (a) -> console.log a

class SessionView extends Backbone.View

  template: ->
    span contenteditable: 'true', ->
      text @model.get 'name'
    ul '.sessions', ->
      for win in @model.get 'wins'
        li ->
          for icon in win.icons
            img src: icon, height: '16', width: '16'
    button '.delete', ->
      text 'Delete'

  tagName: 'li'

  events:
    'click .delete': 'delete'
    'focus span': 'set_carat'
    keyup: 'edited'
    paste: 'edited'

  initialize: ->
    @model.view = @

  edited: ->
     if @model.get('name') isnt @el.firstChild.innerText
       @save()

  save: ->
    @model.save name: @el.firstChild.innerText, silent: true

  render: =>
    $(@el).html coffeecup.render @template, {model: @model}
    @

  delete: ->
    if confirm 'Delete session?'
      @model.destroy()
      $(@el).remove()

  set_carat: ->
    set_carat_at_end $(@el).children('span')[0]

set_carat_at_end = (el) ->
  if (typeof window.getSelection != "undefined" and typeof document.createRange != "undefined") 
    range = document.createRange()
    range.selectNodeContents(el)
    range.collapse(false)
    sel = window.getSelection()
    sel.removeAllRanges()
    sel.addRange(range)
  else if (typeof document.body.createTextRange != "undefined")
    textRange = document.body.createTextRange()
    textRange.moveToElementText(el)
    textRange.collapse(false)
    textRange.select()



load_sessions = ->
  window.sessions = new SessionList
  sessions.each (m) ->
    m.save()

  #chromestorage is async
  sessions.fetch().then ->
    sessions.each (s) ->
      if s.attributes.id
        $('#session-list').append (new SessionView({model: s})).render().el 

    if sessions.size() is 0
      $('#session-list').before '<i>No sessions are saved.</i>'
  
tabindex_setup = ->
  spans = $('#session-list span')
  buttons = $('#session-list button')
  for i in [0...spans.length]
    spans[i].tabIndex = (i * 2) + 1
    buttons[i].tabIndex = (i * 2) + 2

$ ->
  load_sessions()

  tabindex_setup()

  $('#session-list span')[0]?.focus()

