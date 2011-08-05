(function() {
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  $(function() {
    var Session, SessionList, SessionView;
    Session = (function() {
      __extends(Session, Backbone.Model);
      function Session() {
        Session.__super__.constructor.apply(this, arguments);
      }
      return Session;
    })();
    SessionList = (function() {
      __extends(SessionList, Backbone.Collection);
      function SessionList() {
        SessionList.__super__.constructor.apply(this, arguments);
      }
      SessionList.prototype.model = Session;
      SessionList.prototype.localStorage = new Store('sessions');
      return SessionList;
    })();
    window.sessions = new SessionList;
    SessionView = (function() {
      __extends(SessionView, Backbone.View);
      function SessionView() {
        this.render = __bind(this.render, this);
        SessionView.__super__.constructor.apply(this, arguments);
      }
      SessionView.prototype.tagName = 'li';
      SessionView.prototype.events = {
        'click .delete': 'delete'
      };
      SessionView.prototype.initialize = function() {
        this.model.bind('change', this.render);
        return this.model.view = this;
      };
      SessionView.prototype.render = function() {
        this.$(this.el).html('test' + this.model.get('x'));
        return this;
      };
      SessionView.prototype["delete"] = function() {
        this.model.destroy();
        return $(this.el).remove();
      };
      return SessionView;
    })();
    sessions.fetch();
    return sessions.each(function(m) {
      return $('#session-list').append((new SessionView({
        model: m
      })).render().el);
    });
  });
}).call(this);
