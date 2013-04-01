# Ferro

## TODO

Please do contribute! I'm not planning on doing these anytime soon. Open an issue if you'd like to be pointed in the right direction on how to implement something.

* when url has highest score, title is still text-match emboldened 
* history search, if it doesn't clutter the suggestions too much
* icons for commands
* allow for multiple search terms for extract, close, etc.
* show entered capital letters
* have < 5 suggestions if < 5 have a nonzero score
* implement/use pubsub for shortcut, sessions, and chrome.* getters
* weigh scoring for previously-used key sequences
* filter exts/apps when `mayDisable` is false and `cmd` is disable
* make cross-browser with Crossrider
* put tips based on past usage (eg 'try out saving your session') in the broswer action tooltip and options page
* allow omnibox keyword interaction, eg `f extract google.com`
* remove custom compilation system - make modules and require them
* class system for different types of suggestions

## The Code

There is one background script, which along with the options page and action page has access to the extension's local storage and chrome extension API. The background script also maintains sessions state by making changes to local storage and the `f.sessions` global variable in each tab. The options page provides an interface to change sessions and the Ferro keyboard shortcut, and it updates each tab's `f.sessions` and `f.shortcut` variables (via requests to the background) as well as saving the changes to `localStorage`. 

* `commands:` defines available commands
* `chrome-pages:` lists the special `about:` and `chrome://` pages
* `keys:` lists the special keys Ferro recognizes
* `options:` CoffeeKup template of the extension's options page, converted to HTML before packaging
* `options-backbone:` the Backbone.js application that `options` loads
* `popup:` CoffeeKup template of the main UI

Since in all my wisdom I didn't use classes, `types.txt` lists the fields of different types of suggestions.

## Credits

 - Nicholas Jitkoff and the Quicksilver development community for [Quicksilver](http://qsapp.com/), which inspired Ferro
 - Joseph Schmitt for [Snipe extension](https://github.com/josephschmitt/Snipe), which also inspired Ferro
 - Jeremy Ashkenas for [CoffeeScript](http://jashkenas.github.com/coffee-script/)
 - DocumentCloud for [Underscore](http://documentcloud.github.com/underscore/)
 - Joshaven Potter for the [string_score](https://github.com/joshaven/string_score) Javascript library
 - Stallman and Steele for [Emacs](http://www.gnu.org/software/emacs/)
 - Jobs for my Macbook Pro
 - Page and Brin for Chrome :-)
