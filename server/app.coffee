request = require 'request'
#db = require './model'

# --- helpers

l = (x) ->
  console.log x
  
is_valid = (o) ->
  o.amt < 0.5 and o.name?.length > 0 and o.token

# ---------
  
port = process.env.PORT || 80

#db.sequelize.sync()



require('zappajs') port, ->
  @use 'partials'
  @enable 'default layout'

  @get '/': ->
    host = @request.get 'host'
    switch host
      when 'www.getferro.com'
        @make_charge amt: 10000, token: 'tok_2GsMkFGfv7yJet', name: 'me'
        @render www:
          title: 'Ferro: The keyboard interface to Chrome'
      when 'donate.getferro.com'
        db.query(
            'SELECT * FROM donations ORDER BY amt DESC;'
            db.Donation
        ).success (donations) =>
          @send donate: {
            title: 'Donate to Ferro',
            donations
          }
      else   
        'hello there'

  @get '/donations': ->
    db.query(
      'SELECT * FROM donations ORDER BY id DESC LIMIT 5;'
      db.Donation
    ).success (donations) =>
      @send JSON.stringify donations

  @post '/donations': ->
    l 'in post'
    @make_charge() 

  @get '/callback': ->
    unless @params.secret is process.env.COINBASE_CALLBACK
      @send 403

    @save_charge 
      amt: @params.order.total_native.cents
      name: @params.order.custom
  

  @view www: ->
    h1 @title
    p 'what'

  @view donate: ->
    h1 @title
    p @donations[0].name
    p 'what'
    p JSON.stringify @donations

  @helper make_charge: ->
    unless is_valid @params
      @send 'Invalid parameters'

    l 'make_charge o:'
    l o
    l @send
    request
      method: 'POST'
      url: 'https://api.stripe.com/v1/charges'
      form:
        amount: o.amt,
        currency: 'usd',
        card: o.token,
        description: o.name
      headers:
        Authorization: 'Bearer ' + process.env.STRIPE_KEY
    , (error, r, body) =>
      if error
        l 'error:'
        l error
        @send 'error'
      else
        @save_charge @params
        l body.paid
      l body

  @helper save_charge: (o) ->
    l 'save_charge'
    l o
    # params sanitized by build()
  # db.Donation
  #   .build
  #     amt: o.amt
  #     name: o.name
  #     created_at: new Date()
  #   .save()
    @send 'saved donation'





