request = require 'request'
db = require './model'
_ = require 'underscore'
{COMMANDS} = require '../src/coffee/commands'
{sentence_case} = require '../src/coffee/init'

# --- helpers

l = (x) ->
  console.log x
  
is_valid = (o) ->
  o.amt >= 50 and o.name?.length > 0 and o.token

# ---------
  
port = process.env.PORT || 80

db.sequelize.sync()



require('zappajs') port, ->
  @use 'partials', 'static', 'bodyParser'
  @enable 'default layout'

  @get '/': ->
    host = @request.get 'host'
    switch host
      when 'www.getferro.com'
#        @make_charge amt: 10000, token: 'tok_2GsMkFGfv7yJet', name: 'me'
        @render www:
          COMMANDS: COMMANDS
          sentence_case: sentence_case
          title: 'Ferro: The keyboard interface to Chrome'
          scripts: [
            '//ajax.googleapis.com/ajax/libs/jquery/2.0.3/jquery.min.js'
            'js/analytics.js'
            'fancybox/source/jquery.fancybox.js'
            'fancybox/source/helpers/jquery.fancybox-thumbs.js'
            'js/www.js'
          ]
          stylesheets: [
            'css/www.css'
            'fancybox/source/jquery.fancybox.css'
            'fancybox/source/helpers/jquery.fancybox-thumbs.css'
          ]
      when 'donate.getferro.com'
        db.sequelize.query(
            'SELECT * FROM "Donations";'
            db.Donation
        ).success (rs) =>
#        rs = [{name: 'Ethan', amt: 100, created_at: new Date()},{name: 'Anonymous', amt: 995, created_at: new Date()}]
          amts = _.pluck rs, 'amt'
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
              'https://checkout.stripe.com/v2/checkout.js'
              'https://coinbase.com/assets/button.js'
              'js/main.js'
            ]
            stylesheets: [
              'css/table.css'
              'css/donate.css'
            ]
      else   
        'hello there'

  @get '/donations': ->
    db.sequelize.query(
      'SELECT * FROM "Donations" ORDER BY created_at DESC LIMIT 5;'
      db.Donation
    ).success (donations) =>
      @send JSON.stringify donations

  @post '/donations': ->
    l @body
    l @body.name
    @make_charge() 

  @post '/callback': ->
    l @query
    l process.env.COINBASE_CALLBACK
    unless @query.secret is process.env.COINBASE_CALLBACK
      @send 403
      return

    @save_charge 
      amt: @body.order.total_native.cents
      name: @body.order.custom
  
  @helper make_charge: ->
    l 'make_charge body:'
    l @body

    unless is_valid @body
      @send 'Invalid parameters'
      return

    request
      method: 'POST'
      url: 'https://api.stripe.com/v1/charges'
      form:
        amount: @body.amt,
        currency: 'usd',
        card: @body.token,
        description: @body.name
      headers:
        Authorization: 'Bearer ' + process.env.STRIPE_KEY
    , (error, r, body) =>
      if error
        l 'error:'
        l error
        @send 'error'
      else
        @save_charge @body
        l body.paid
      l body

  @helper save_charge: (o) ->
    l 'save_charge'
    l o
    # params sanitized by build()
    db.Donation
      .build
        amt: o.amt
        name: o.name[0...30]
        created_at: new Date()
      .save()
    @send 'saved donation'





