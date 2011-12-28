t = text

doctype 5
html ->
  head ->
    title 'Ferro'
    link
      href: '../options.css'
      media: 'all'
      rel: 'stylesheet'
      type: 'text/css'
    script src: 'vendor/json2.js'
    script src: 'vendor/jquery.js'
    script src: 'vendor/underscore.js'
    script src: 'vendor/underscore.string.min.js'
    script src: 'vendor/backbone.js'
    script src: 'vendor/backbone-localstorage.js'
    script src: 'options-backbone.js'
  body ->
    h1 'Ferro'
    p ->
      t 'Note that Ferro does not work on any special '
      code 'chrome://'
      t 'pages, including this one, or the Chrome Web Store. It also does not work on pages that have not finished loading and some pages that have their own keyboard shortcuts.'
    h3 'Saved Sessions'
    ul id: 'session-list', ->
    h3 'Keyboard Shortcut'
    input type: 'text'
    p class: 'small', 'Recognized modifiers: Shift, Ctrl, and Alt'
    h3 'Commands'
    table ->
      tr ->
        th 'Name'
        th 'Description'
      for name, cmd of f.COMMANDS
        tr ->
          td sentence_case name
          td cmd.desc
    h2 'Recommendations'
    h3 'Other extensions'
    ul ->
    	li ->
    	  a href: 'https://chrome.google.com/webstore/detail/dbepggeogbaibhgnhhndojpepiihcmeb', -> 'Vimium'
    	  ': Provides better keyboard navigation. You can even customize the shortcuts to better match the one true editor.'
    	li ->
    	  a href: 'https://chrome.google.com/webstore/detail/hdokiejnpimakedhajhdlcegeplioahd', -> 'Lastpass'
    	  ': Automatically generate, remember, and fill in random passwords.'
    	li ->
    	  a href: 'https://chrome.google.com/webstore/detail/bjclhonkhgkidmlkghlkiffhoikhaajg', -> 'Greplin'
    	  ': Search your data.'
    	li ->
    	  a href: 'https://chrome.google.com/webstore/detail/gijmaphaippejlhagngohjmehmanbehd', -> 'QuickShift'
    	  ': Move Chrome tabs to a different window or to a new location within the current window using your keyboard.'
    	li ->
    	  a href: 'https://chrome.google.com/webstore/detail/ahmiiblnmmnijkhboligioinfchkeagi', -> 'Minimalist for Facebook'
    	li ->
    	  a href: 'https://chrome.google.com/webstore/detail/mgljgiacemcbnibkkmbolnljeffaadna', -> 'Minimalist for Google Calendar'
    	li ->
    	  a href: 'https://chrome.google.com/webstore/detail/oddhbkghjoccbljmagcgoklbfdjeiinb', -> 'Minimalist for Gmail'
    	li ->
    	  a href: 'https://chrome.google.com/webstore/detail/hihakjfhbmlmjdnnhegiciffjplmdhin', -> 'Rapportive'
    	  ': Replaces Gmail right-hand sidebar with information about with whom you are corresponding.'
      li ->
        a href: 'http://defunkt.io/dotjs/', -> 'Dotjs'
        ': Better than Greasemonkey'
    h3 ->
      t 'Features to enable in '
      a href: 'chrome://flags', ->
        code 'chrome://flags'
    ul ->
    	li 'Tab Overview'
    	li 'GPU Accelerated Compositing'
    	li 'Print Preview'
    	li 'Web Page Prerendering -> Always Enabled'
    	li 'Confirm to Quit'
    	li 'Click to play'
    	li 'Enable better omnibox history matching'


*Transfer Recipient's Last Name: 
*Transfer Recipient's Account Number:
*Transfer Recipient's Zip Code: