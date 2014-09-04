# Ferro

[![Flattr this git repo](http://api.flattr.com/button/flattr-badge-large.png)](https://flattr.com/submit/auto?user_id=loren&url=http%3A%2F%2Fwww.getferro.com&title=Ferro&tags=github&category=software) 

## TODO

Please do contribute! I'm not planning on working on the below items. Open an issue or WIP pull request if you'd like to be pointed in the right direction on how to implement something.

* save command history and display on options page along with usage statistics/graphs
* enable scrolling past 5th suggestion
* allow clicking on and reordering saved session icons and rows of icons 
* allow omnibox keyword interaction, eg `f extract google.com`
* remember what keys people press and what action they take to improve future suggestions
* refactor popup into a backbone app
* take logic out of templates
* remove custom compilation system - make modules and require them
* make icons fade to transparent
* when url has highest score, title is still text-match emboldened 
* allow for multiple search terms for extract, close, etc.
* show entered capital letters
* filter exts/apps when `mayDisable` is false and `cmd` is disable
* make cross-browser with Crossrider
* put tips based on past usage (eg 'try out saving your session') in the broswer action tooltip and options page
* class system for different types of suggestions
* write tests, need to mock chrome api for some parts

### When the manifest command limit of 4 is lifted

```
	"kill": {
	    "suggested_key": {
		"default": "Alt+Shift+K"
	    }
	}
```

## Code Structure

The extension code is in `src/`. There is one background script, which along with the options page and action page has access to the extension's local storage and chrome extension API. The background script also maintains sessions state by making changes to local storage and the `f.sessions` global variable in each tab. The options page provides an interface to change sessions and the Ferro keyboard shortcut, and it updates each tab's `f.sessions` and `f.shortcut` variables (via requests to the background) as well as saving the changes to `localStorage`. 

* `commands:` defines available commands
* `chrome-pages:` lists the special `about:` and `chrome://` pages
* `keys:` lists the special keys Ferro recognizes
* `options:` Coffeecup template of the extension's options page, converted to HTML before packaging
* `options-backbone:` the Backbone.js application that `options` loads
* `popup:` Coffeecup template of the main UI
* `template-loader`: loads popup and sets up Easter egg

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
