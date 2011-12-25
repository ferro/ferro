#https://github.com/documentcloud/backbone/raw/master/backbone.js
#https://github.com/douglascrockford/JSON-js/raw/master/json2.js

task :default => :watch

task :watch do
  exec 'coffee -cw -o extension/js/ src/cs/'
  exec 'sass --watch src/sass/:extension/'
  exec 'coffeekup -fw -o extension/js/ src/coffeekup/options.coffee'
end

task :op do
  `node_modules/coffeekup/bin/coffeekup -fw -o extension/js/ src/coffeekup/options.coffee &`
  `sass --watch src/sass/:extension/`
end

task :options do
  `cat src/cs/keys.coffee > tmp.coffee`
  `cat src/cs/options-backbone.coffee >> tmp.coffee`
  `coffee -c -o extension/js/ tmp.coffee`
  `rm tmp.coffee`
  `mv extension/js/tmp.js extension/js/options-backbone.js`
end

def exec cmd
  Thread.new(cmd) do |tcmd|
    IO.popen tcmd do |fd|
      until fd.eof?
        puts fd.readline
        sleep 10
      end
    end
  end
end

task :vendor do
  get 'http://code.jquery.com/jquery-1.7.1.js', 'jquery.js' 
  get 'http://documentcloud.github.com/underscore/underscore.js'
  get 'https://raw.github.com/jeromegn/Backbone.localStorage/master/backbone.localStorage.js', 'backbone-localstorage.js'
end

def get url, name = nil
  name = url[url.rindex('/')+1..-1] unless name
  `wget #{url} -O extension/js/vendor/#{name}`
end

