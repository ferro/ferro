port = process.env.PORT || 3000

require('zappajs') 'donate.getferro.com', port, ->
  @get '/': 'donate'

require('zappajs') 'www.getferro.com', port, ->
  @get '/': 'www'

require('zappajs') port, ->
  @get '/': 'hi'