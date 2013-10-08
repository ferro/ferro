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

db?.sequelize.sync()



require('zappajs') port, ->
  @use 'partials', 'static', 'bodyParser'

  @get '/': ->
    host = @request.get 'host'
    switch host
      when 'www.getferro.com'
        @render www:
          COMMANDS: COMMANDS
          sentence_case: sentence_case
          title: 'Ferro: The keyboard interface to Chrome'
          scripts: [
            '//ajax.googleapis.com/ajax/libs/jquery/2.0.3/jquery.min'
            'js/init'
            'js/analytics'
            'fancybox/source/jquery.fancybox'
            'fancybox/source/helpers/jquery.fancybox-thumbs'
            'js/www'
          ]
          stylesheets: [
            'css/www'
            'fancybox/source/jquery.fancybox'
            'fancybox/source/helpers/jquery.fancybox-thumbs'
          ]
        , layout: 'layout'
      when 'donate.getferro.com'
        db.sequelize.query(
            'SELECT * FROM "Donations";'
            db.Donation
        ).success (rs) =>
          amts = _.pluck rs, 'amt'
          sum_fn = (acc, amt) ->
            acc + amt
          sum = _.reduce amts, sum_fn, 0

          @render donate:
            donations: rs
            total: (sum/100).toFixed 2
            title:'Ferro Donations'
            scripts: [
              '//ajax.googleapis.com/ajax/libs/jquery/2.0.3/jquery.min'
              'js/jquery.tablesorter.min'
              'js/init'
              'js/analytics'
              'js/donate'
              'https://checkout.stripe.com/v2/checkout'
              'https://coinbase.com/assets/button'
              'js/main'
            ]
            stylesheets: [
              'css/table'
              'css/donate'
            ]
          , layout: 'layout'
      else   
        'hello there'

  @get '/donations': ->
    db.sequelize.query(
      'SELECT * FROM "Donations" ORDER BY created_at DESC LIMIT 5;'
      db.Donation
    ).success (donations) =>
      @send JSON.stringify donations

  @post '/donations': ->
    @make_charge() 

  @post '/callback': ->
    unless @query.secret is process.env.COINBASE_CALLBACK
      @send 403
      return

    cents = @body.order.total_native.cents
    return if cents < 50

    @save_charge 
      amt: cents
      name: @body.order.custom
  
  @helper make_charge: ->
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
      json = JSON.parse body
      if error or json.error
        @send 'error'
      else
        @save_charge @body


  @helper save_charge: (o) ->
    # values sanitized by build()
    db.Donation
      .build
        amt: o.amt
        name: o.name[0...30]
        created_at: new Date()
      .save()
    @send 'saved donation'


  @view layout: ->
    doctype 5
    html ->
      head ->
        title @title if @title
        if @scripts
          for s in @scripts
            script src: s + '.js'
        script(src: @script + '.js') if @script
        if @stylesheets
          for s in @stylesheets
            link rel: 'stylesheet', href: s + '.css'
        link(rel: 'stylesheet', href: @stylesheet + '.css') if @stylesheet
        style @style if @style
        link rel: 'icon', type: 'image/png', href: 'favicon.gif'
      body @body
    

