class Session extends Backbone.Model

class SessionList extends Backbone.Collection
  model: Session
  localStorage: new Backbone.LocalStorage 'sessions'
  get_by_name: (name) ->
    @each (s) ->
      return s if s.get('name') is name

sessions = new SessionList

