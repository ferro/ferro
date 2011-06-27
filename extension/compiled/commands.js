(function() {
  var move_to_new_window, prepare;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  f.commands = {
    extract: {
      desc: "Extract tabs that match the given text into a new window. Uses the current tab's domain if text is blank.",
      context: 'text',
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
      desc: "Pin tab. Uses current tab if text is blank.",
      context: ['tab', 'text'],
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
      desc: "Unpin tab. Uses current tab if text is blank.",
      context: ['tab', 'text'],
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
      desc: "Select tab.",
      context: 'tab',
      fn: function(x, tab) {
        return chrome.tabs.update(tab.id, {
          selected: true
        });
      }
    },
    enable: {
      context: ['extension', 'app'],
      fn: function(x, ext) {
        return chrome.management.setEnabled(ext.id, true);
      }
    },
    disable: {
      context: ['extension', 'app'],
      fn: function(x, ext) {
        return chrome.management.setEnabled(ext.id, false);
      }
    },
    options: {
      desc: 'Open the options page.',
      context: ['extension', 'app'],
      fn: function(x, ext) {
        return f.open(ext.optionsUrl);
      }
    },
    describe: {
      context: ['extension', 'app'],
      fn: function(x, ext) {
        return f.display(ext.description + ' -- Version: ' + ext.version);
      }
    },
    homepage: {
      context: ['extension', 'app'],
      fn: function(x, ext) {
        return f.open(ext.homepageUrl);
      }
    },
    launch: {
      context: 'app',
      fn: function(x, app) {
        return chrome.management.launchApp(app.id);
      }
    },
    uninstall: {
      context: ['extension', 'app'],
      fn: function(x, ext) {
        return chrome.management.uninstall(ext.id);
      }
    },
    save: {
      desc: "Save the current window with the name given.",
      context: 'text',
      fn: function(tab, name) {
        return chrome.windows.get(tab.windowId, function(win) {
          return f.sessions.add(name, prepare(win));
        });
      }
    },
    save_all: {
      desc: "Save all open windows with the name given.",
      context: 'text',
      fn: function(x, name) {
        return chrome.windows.getAll({
          populate: true
        }, function(wins) {
          var win, _i, _len, _results;
          _results = [];
          for (_i = 0, _len = wins.length; _i < _len; _i++) {
            win = wins[_i];
            _results.push(f.sessions.add(name, prepare(win)));
          }
          return _results;
        });
      }
    },
    remove: {
      desc: "Open saved session.",
      context: 'session',
      fn: function(x, session) {
        return open(session);
      }
    }
  };
  prepare = function(win) {
    return _.extend(_.copy(win, 'left', 'top', 'width', 'height'), {
      url: _(win.tabs).pluck('url')
    });
  };
  move_to_new_window = function(regex) {
    var first_tab, _i, _len, _ref;
    _ref = f.tabs;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      first_tab = _ref[_i];
      if (regex.test(tab.url)) {
        chrome.windows.create({
          focused: true,
          tabId: first_tab.id
        }, __bind(function(win) {
          var tab, _j, _len2, _ref2, _results;
          first_tab.winId = win.id;
          _ref2 = f.tabs;
          _results = [];
          for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
            tab = _ref2[_j];
            if (regex.test(tab.url)) {
              _results.push(chrome.tabs.move(tab.id({
                windowId: win.id,
                index: 0
              })));
            }
          }
          return _results;
        }, this));
        return;
      }
    }
  };
}).call(this);
