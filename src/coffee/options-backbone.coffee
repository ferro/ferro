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
#<img src="chrome://favicon/http://www.google.com/">
  # 
  delete: ->
    if confirm 'Delete session?'
      @model.destroy()
      $(@el).remove()

  set_carat: ->
    set_carat_at_end $(@el).children('span')[0]



load_sessions = ->
  sessions = new SessionList
  sessions.each (m) ->
    l m  
    m.save()

  sessions.fetch()
  sessions.each (s) =>
    if s.attributes.id
      l 'adding li'
      l s
      $('#session-list').append (new SessionView({model: s})).render().el 

  if sessions.size() is 0
    $('#session-list').before '<i>None</i>'
  

DEFAULT_AMT = 9.95
  
amt = DEFAULT_AMT

update_amount_left = ->
  $('#stripe + span').val '$ ' + Math.max(
    amt - (amt * 0.029) - 0.30,
    0
  )
  $('#bitcoin + span').val '$ ' + Math.max(amt, 0)
  
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
  
  load_sessions()

  if $('span')[0]
    $('span')[0].focus()

  if localStorage.donated
    $('#donate').hide()

  $.get 'https://donate.getferro.com/donations', (data) ->
    for donation in data.donations
      $('#donations').append $("<li>#{donation.donor}<code>$#{donation.amount}</code></li>")

  update_amount_left()

  $('#amount').on 'change keyup paste input', ->
    new_amt = parseFloat($('#amount').val()).toFixed 2
    if new_amt is not amt
      amt = new_amt
      update_amount_left()

  $('button').click (e) ->
    #todo placeholders
    if e.target.id is 'stripe'
      if amt <= 0.5
        alert 'Minimum card charge is 50 cents.'
        return
  
      token = (res) =>
        $.post 'https://donate.getferro.com/', {token: res.id, name: $('#name').val(), amount: amt} 
        localStorage.donated = true
        $('#donate').empty()
        orders = amt / DEFAULT_AMT
        $('#donate').append("<p>Thank you so much for your donation of #{orders.toFixed 2} order#{'s' unless orders is 1} of chicken panang!</p>")

      StripeCheckout.open 
        key:         'pk_test_dqK3ga37dNAty3AQsvfEq2pe',
        amount:      amt,
        currency:    'usd',
        name:        'Ferro',
        description: 'Donation',
        panelLabel:  'Donate',
        token:       token
        image:       'images/icon-128.gif'
    else
      location.href = "https://coinbase.com/checkouts/86fb2558897c24d5cfed70fe4f033f20"

