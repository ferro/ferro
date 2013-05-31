window.l = (a) -> console.log a

class SessionView extends Backbone.View

  template: ->
    span contenteditable: 'true', ->
      text @model.get 'name'
    ul '.sessions', ->
      for win in @model.get 'wins'
        li ->
          for icon in win.icons
            img src: icon, height: '16', width: '16' #todo chrome://favicon, and in manifest permissions
    button '.delete', ->
      text 'Delete'

  tagName: 'li'

  events:
    'click .delete': 'delete'
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
#<img src="chrome://favicon/http://www.google.com/">
  # 
  delete: ->
    if confirm 'Delete session?'
      @model.destroy()
      $(@el).remove()

$ =>
# sessions.fetch()
  
  # for i in [0..sessions.length]
  #   sessions.at(0)?.destroy()

  # sessions.add [
  #   {name: 'two', wins: [
  #     {icons:["http://www.google.com/images/google_favicon_128.png","http://www.google.com/images/google_favicon_128.png"]}
  #     {icons:["http://www.google.com/images/google_favicon_128.png"]}
  #   ]}
  #   {name: 'one', wins: [
  #     {icons:["http://www.google.com/images/google_favicon_128.png","http://www.google.com/images/google_favicon_128.png"]}
  #   ]}
  # ]


  l 'start'
  sessions.each (m) ->
    l m  
    m.save()

  sessions.fetch()
  sessions.each (s) =>
    if s.attributes.id
      $('#session-list').append (new SessionView({model: s})).render().el 

  if sessions.size() is 0
    $('#session-list').before '<i>None</i>'

  if $('span')[0]
    $('span')[0].focus()
    
  

