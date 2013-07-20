port = process.env.PORT || 3000

require('zappajs') port, ->
  @get '/': 'hi'