(function() {
  var add_session, get_tabs, move_to_new_window, open_session, prepare;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  f.CONTEXTS = {
    TAB: 0,
    EXTENSION: 1,
    APP: 2,
    SESSION: 3,
    TEXT: 4
  };
  f.COMMANDS = {
    search_history: {
      desc: 'Search through your history.',
      context: f.CONTEXTS.TEXT,
      fn: function(x, text) {
        return f.open('chrome://history/#q=' + text + '&p=0');
      }
    },
    extract: {
      desc: "Extract tabs that match the given text into a new window. Uses the current tab's domain if text is blank.",
      context: f.CONTEXTS.TEXT,
      fn: function(tab, text) {
        var domain, http;
        if (text === '') {
          if (_(tab.url).startsWith('chrome' || _(tab.url).startsWith('about'))) {
            return move_to_new_window(/^(chrome|about)/);
          } else {
            http = '^https*://';
            domain = tab.url.match(new RegExp(http + '(.*\..{2,4}/)', 'i'))[1];
            return move_to_new_window(new RegExp(http + domain, 'i'));
          }
        } else {
          return move_to_new_window(new RegExp(text, 'i'));
        }
      }
    },
    pin: {
      desc: 'Pin tab. Uses current tab if text is blank.',
      context: [f.CONTEXTS.TAB, f.CONTEXTS.TEXT],
      fn: function(current_tab, tab) {
        if (tab === '') {
          tab = current_tab;
        }
        return chrome.tabs.update(tab.id, {
          pinned: true
        });
      }
    },
    unpin: {
      desc: 'Unpin tab. Uses current tab if text is blank.',
      context: [f.CONTEXTS.TAB, f.CONTEXTS.TEXT],
      fn: function(current_tab, tab) {
        if (tab === '') {
          tab = current_tab;
        }
        return chrome.tabs.update(tab.id, {
          pinned: false
        });
      }
    },
    select: {
      desc: 'Select tab.',
      context: f.CONTEXTS.TAB,
      fn: function(x, tab) {
        return chrome.tabs.update(tab.id, {
          selected: true
        });
      }
    },
    enable: {
      context: [f.CONTEXTS.EXTENSION, f.CONTEXTS.APP],
      fn: function(x, ext) {
        return chrome.management.setEnabled(ext.id, true);
      }
    },
    disable: {
      context: [f.CONTEXTS.EXTENSION, f.CONTEXTS.APP],
      fn: function(x, ext) {
        return chrome.management.setEnabled(ext.id, false);
      }
    },
    options: {
      desc: 'Open the options page.',
      context: [f.CONTEXTS.EXTENSION, f.CONTEXTS.APP],
      fn: function(x, ext) {
        return f.open(ext.optionsUrl);
      }
    },
    describe: {
      context: [f.CONTEXTS.EXTENSION, f.CONTEXTS.APP],
      fn: function(x, ext) {
        return f.display(ext.description + ' -- Version: ' + ext.version);
      }
    },
    homepage: {
      context: [f.CONTEXTS.EXTENSION, f.CONTEXTS.APP],
      fn: function(x, ext) {
        return f.open(ext.homepageUrl);
      }
    },
    launch: {
      context: f.CONTEXTS.APP,
      fn: function(x, app) {
        return chrome.management.launchApp(app.id);
      }
    },
    uninstall: {
      context: [f.CONTEXTS.EXTENSION, f.CONTEXTS.APP],
      fn: function(x, ext) {
        return chrome.management.uninstall(ext.id);
      }
    },
    save: {
      desc: 'Save the current window with the name given.',
      context: f.CONTEXTS.TEXT,
      fn: function(tab, name) {
        return chrome.windows.get(tab.windowId, __bind(function(win) {
          return add_session(name, [prepare(win)]);
        }, this));
      }
    },
    save_all: {
      desc: 'Save all open windows with the name given.',
      context: f.CONTEXTS.TEXT,
      fn: function(x, name) {
        return chrome.windows.getAll({
          populate: true
        }, function(wins) {
          var win, _i, _len, _results;
          _results = [];
          for (_i = 0, _len = wins.length; _i < _len; _i++) {
            win = wins[_i];
            _results.push(add_session(name, prepare(win)));
          }
          return _results;
        });
      }
    },
    open: {
      desc: 'Open saved session.',
      context: f.CONTEXTS.SESSION,
      fn: function(x, session) {
        return open_session(session);
      }
    },
    remove: {
      desc: 'Delete saved session.',
      context: f.CONTEXTS.SESSION,
      fn: function(x, session) {
        return open_session(session);
      }
    }
  };
  prepare = function(win) {
    return _.extend(_.copy(win, 'left', 'top', 'width', 'height', 'focused'), {
      url: _(win.tabs).pluck('url')
    });
  };
  move_to_new_window = function(regex) {
    var tabs;
    tabs = get_tabs(regex);
    return chrome.windows.create({
      focused: true,
      tabId: tabs[0].id
    }, __bind(function(win) {
      var i, _ref, _results;
      _results = [];
      for (i = 1, _ref = tabs.length; 1 <= _ref ? i <= _ref : i >= _ref; 1 <= _ref ? i++ : i--) {
        _results.push(chrome.tabs.move(tabs[i].id, {
          windowId: win.id,
          index: 0
        }));
      }
      return _results;
    }, this));
  };
  get_tabs = function(regex) {
    return chrome.windows.getAll({
      populate: true
    }, __bind(function(wins) {
      var tab, win, _i, _len, _ref, _results;
      _ref = _.flatten((function() {
        var _j, _len, _results2;
        _results2 = [];
        for (_j = 0, _len = wins.length; _j < _len; _j++) {
          win = wins[_j];
          _results2.push(win.tabs);
        }
        return _results2;
      })());
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        tab = _ref[_i];
        if (regex.test(tab.url)) {
          _results.push(tab);
        }
      }
      return _results;
    }, this));
  };
  open_session = function(session) {
    var win, _i, _len, _ref, _results;
    _ref = session.wins;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      win = _ref[_i];
      _results.push(chrome.windows.create(win));
    }
    return _results;
  };
  add_session = function(name, wins) {
    return chrome.extension.sendRequest({
      action: 'create',
      type: 'session',
      value: {
        name: name,
        wins: wins
      }
    }, function(response) {});
  };
}).call(this);
