request = require 'request'
#db = require './model'
_ = require 'underscore'

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
  @use 'static'

  @get '/': ->
    host = @request.get 'host'
    switch host
      when 'www.getferro.com'
#        @make_charge amt: 10000, token: 'tok_2GsMkFGfv7yJet', name: 'me'
        @render www:
          title: 'Ferro: The keyboard interface to Chrome'
          scripts: [
            'js/analytics.js'
          ]
          stylesheets: [
            'css/www.css'
          ]
      when 'donate.getferro.com'
        # db.query(
        #     'SELECT * FROM donations ORDER BY amt DESC;'
        #     db.Donation
        # ).success (@donations) =>
        rs = [{name: 'Ethan', amt: 100, created_at: new Date()},{name: 'Anonymous', amt: 995, created_at: new Date()}]
        amts = _.pluck(rs, 'amt')
        sum_fn = (acc, amt) ->
          acc + amt
        sum = _.reduce amts, sum_fn, 0

        @render donate:
          donations: rs
          total: (sum/100).toFixed 2
          title:'Ferro Donations'
          scripts: [
            '//ajax.googleapis.com/ajax/libs/jquery/2.0.3/jquery.min.js'
            'js/jquery.tablesorter.min.js'
            'js/init.js'
            'js/analytics.js'
            'js/donate.js'
            'js/main.js'
            'https://checkout.stripe.com/v2/checkout.js'
            'https://coinbase.com/assets/button.js'
          ]
          stylesheets: [
            'css/table.css'
            'css/donate.css'
          ]
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
  #     name: o.name[0...30]
  #     created_at: new Date()
  #   .save()
    @send 'saved donation'





