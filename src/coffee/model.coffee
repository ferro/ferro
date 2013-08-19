class Session extends Backbone.Model

class SessionList extends Backbone.Collection
  model: Session
  chromeStorage: new Backbone.ChromeStorage 'sessions', 'sync'
  get_by_name: (name) ->
    match = null
    @each (s) ->
      match = s if s.get('name') is name
    match



