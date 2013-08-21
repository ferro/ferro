section '#main', ->
  h1 '.title', 'Ferro Donations'
  nav '.center', ->
    a href: 'http://www.getferro.com', 'getferro.com'
  div '#total.center', ->
    text 'Total: $' + @total
  table id: 'donations-table', class: 'tablesorter', ->
    thead ->
      tr ->
        th 'Name'
        th 'Amount'
        th 'Date'
    tbody ->
      for donation in @donations
        tr ->
          td donation.name
          td '$ ' + (donation.amt / 100.0).toFixed 2
          td donation.created_at.toString()
   
# modified version of ferro/src/coffeecup/options.coffee
# TODO unduplicate
aside '#donate', ->
  img src: 'panang.jpg', height: '120', width: '120'
  label 'Chicken Panang Curry (พะแนง) is $9.95'
  h2 'Feed me?'
  p '#feeding', 'I emphatically adore Thai vittles. Your donation will endow my occasional excursions to the local Thai restaurant and thereupon deliver felicity to my life.'
  ul '#form', ->
    li ->
      label 'Donor name:'
      input id: 'name', type: 'text', value: 'Anonymous', tabindex: '100'
    li ->
      label 'Amount:'
      input id: 'amount', type: 'number', value: '9.95', tabindex: '101'
  div '.header', 'Amount left after processing fees:'
  ul '#options', ->
    li ->
      span '.stripe', '$ 9.36'
      button '#stripe.action', 'Use credit card', tabindex: '102'
    li ->
      span '.bitcoin', '$ 9.95'
      button '#bitcoin.action', 'Use bitcoins', tabindex: '103'
  p '#list', 'Most recent donations: '
  table id: 'donations', ->
    tr ->
      td ''
      td ''
      td ''
    tr ->
      td ''
      td ''
      td ''
    tr ->
      td ''
      td ''
      td ''
    tr ->
      td ''
      td ''
      td ''
    tr ->
      td ''
      td ''
      td ''
  div '.coinbase-button', ''
