# Ferro

# The Code

* content-script: loaded into every tab, and it listens to key events and handles the UI
* keys: lists the special keys Ferro recognizes
* commands: defines the available commands
* chrome-pages: lists the special `about:` and `chrome://` pages
* options: CoffeeKup template of the extension's options page
* options-backbone: the Backbone.js application that `options` loads

# TODO

Please do contribute! I'm not planning on doing these anytime soon unless there is an unexpected high usage/demand. Message me if you'd like to be pointed in the right direction on how to implement something.

* show entered capital letters
* have < 5 suggestions if < 5 have a nonzero score
* implement/use pubsub for shortcut, sessions, and chrome.* getters
* weight scoring for previously-used key sequences

# Credits

 - Nicholas Jitkoff and the Quicksilver development community for [Quicksilver](http://qsapp.com/), which inspired Ferro.
 - Joseph Schmitt for [Snipe extension](https://github.com/josephschmitt/Snipe), which also inspired Ferro.
 - Jeremy Ashkenas for [CoffeeScript](http://jashkenas.github.com/coffee-script/).
 - DocumentCloud for [Underscore](http://documentcloud.github.com/underscore/).
 - Joshaven Potter for the [string_score](https://github.com/joshaven/string_score) Javascript library.
 - Stallman and Steele for [Emacs](http://www.gnu.org/software/emacs/)
 - Jobs for my Macbook Pro
 - Page and Brin for Chrome :-)
