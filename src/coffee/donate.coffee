DEFAULT_AMT = 995
  
amt = DEFAULT_AMT

complete = (type, result = null) ->
  name = $('#name').val()
  track 'Donations', type, name, amt
  if type is 'stripe'
    $.post 'https://donate.getferro.com/donations', {token: result.id, name, amt}

  donated = true
  orders = (amt / DEFAULT_AMT).toFixed 2

  $('#donate').hide()
  $('#donate').append """<p class="thankyou">Thank you for donating #{orders} order#{'s' unless orders is '1'} of chicken panang!</p>"""

  chrome?.storage?.sync.set {donated, orders}


update_amount_left = ->
  left = (Math.max(
    amt - (amt * 0.029) - 30
    0
  )/100).toFixed 2
  $('.stripe').text '$ ' + left
  
  $('.bitcoin').text '$ ' + (Math.max(amt, 0)/100).toFixed 2

$ ->
  # how do you have '-' in attr name in coffeecup?
  $('.coinbase-button')
    .attr('data-code', '5bb2f730894ac0de1df2fff0c3bdd8fe')
    .attr('data-button-style', 'none')

  chrome?.storage?.sync.get 'donated', (data) ->
    if chrome.extension and data.donated
      $('#donate > img').hide()
      $('#donate').append THANK_YOU

  $.get 'http://donate.getferro.com/donations', (data) ->
    for donation, i in JSON.parse(data)
      tr = $("#donations tr:nth-child(#{i+1})")
      tr.find('td:nth-child(1)').text donation.name
      tr.find('td:nth-child(2)').text '$ ' + (donation.amt/100.0).toFixed 2

      d = new Date(donation.created_at)
      tr.find('td:nth-child(3)').text d.getMonth() + '/' + d.getDate() + '/' + d.getFullYear()

  update_amount_left()

  $('#amount').on 'change keyup paste input', ->
    new_amt = parseFloat($('#amount').val()) * 100
    if new_amt isnt amt
      amt = new_amt
      update_amount_left()

  $('#stripe').click (e) ->
    track 'Donation clicks', 'stripe'

    if amt <= 50
      alert 'Minimum card charge is 50 cents.'
      return
  
    token = (res) =>
      complete 'stripe', res

    StripeCheckout.open 
      key:         'pk_test_dqK3ga37dNAty3AQsvfEq2pe',
      amount:      amt,
      currency:    'usd',
      name:        'Ferro',
      description: 'Donation',
      panelLabel:  'Donate',
      token:       token
      image:       'images/icon-128.gif'

  $('#bitcoin').click ->
    track 'Donation clicks', 'bitcoin'
    $('.coinbase-button').attr 'data-custom', $('#name').val()
    $(document).trigger 'coinbase_show_modal', '5bb2f730894ac0de1df2fff0c3bdd8fe'
    false

  $(document).on 'coinbase_payment_complete', (e, code) ->
    complete 'bitcoin'
