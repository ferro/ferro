# Ferro

# TODO

Please do contribute! I'm not planning on doing these anytime soon. Message me if you'd like to be pointed in the right direction on how to implement something.

* icons for commands
* allow for multiple search terms for extract, close, etc.
* show entered capital letters
* have < 5 suggestions if < 5 have a nonzero score
* implement/use pubsub for shortcut, sessions, and chrome.* getters
* weight scoring for previously-used key sequences
* class system for different types of suggestions
* filter exts/apps when mayDisable is false and cmd is disable

# The Code

There is an instance of content script in each tab, and it brings up and handles the main Ferro UI when the shortcut is hit. There is one background script, which along with the options page has access to the extension's local storage and chrome extension API. The content script sends commands to the background script, which executes them. The background script also maintains sessions state by making changes to local storage and the `f.sessions` global variable in each tab. The options page provides an interface to change sessions and the Ferro keyboard shortcut, and it updates each tab's `f.sessions` and `f.shortcut` variables as well as saving the changes to local storage. 

* `content-main:` the main logic of the content script - it listens to key events, dispatches commands from a state machine, and renders the UI
* `keys:` lists the special keys Ferro recognizes
* `commands:` defines the available commands
* `chrome-pages:` lists the special `about:` and `chrome://` pages
* `background:` injects content script on initial run, handles session update requests from the content scripts
* `options-backbone:` the Backbone.js application that `options` loads
* `options:` CoffeeKup template of the extension's options page, converted to HTML before packaging
* `ferro:` CoffeeKup template of the main UI, converted to JS before packaging

# Credits

 - Nicholas Jitkoff and the Quicksilver development community for [Quicksilver](http://qsapp.com/), which inspired Ferro
 - Joseph Schmitt for [Snipe extension](https://github.com/josephschmitt/Snipe), which also inspired Ferro
 - Jeremy Ashkenas for [CoffeeScript](http://jashkenas.github.com/coffee-script/)
 - DocumentCloud for [Underscore](http://documentcloud.github.com/underscore/)
 - Joshaven Potter for the [string_score](https://github.com/joshaven/string_score) Javascript library
 - Stallman and Steele for [Emacs](http://www.gnu.org/software/emacs/)
 - Jobs for my Macbook Pro
 - Page and Brin for Chrome :-)
