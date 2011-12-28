#https://github.com/documentcloud/backbone/raw/master/backbone.js
#https://github.com/douglascrockford/JSON-js/raw/master/json2.js

task :default => :watch

task :watch do
  exec 'coffee -cw -o extension/js/ src/cs/'
  exec 'sass --watch src/sass/:extension/'
  exec 'coffeekup -fw -o extension/js/ src/coffeekup/options.coffee'
end

task :op do
#  `node_modules/coffeekup/bin/coffeekup -fw -o extension/js/ src/coffeekup/options.coffee &`
  `sass --watch src/sass/:extension/`
end

task :options_template do
  compile(
          :coffeekup,
          [],
          [
           'init',
           'chrome-pages',
           'commands'
          ],
          'options',
          "
window = {}
f = {}
"
          )
end

task :options do
  compile(
          :coffee,
          [
           'jquery',
           'underscore',
           'backbone',
           'backbone-localStorage'
          ],
          [
           'init',
           'model',
           'keys',
           'options-backbone',
           'options-backbone'
          ]
          )
end

task :background do
  compile(
          [
           'jquery',
           'underscore',
           'backbone',
           'backbone-localStorage'
          ],
          [
           'init',
           'model',
           'keys',
           'background',
           'background'
          ]
          )
end

task :content do
  compile(
          [
           'underscore',
           'underscore.string'
          ],
          [
           'underscore-extensions',
           'init',
           'keys',
           'chrome-pages',
           'commands',
           'content-main',
           'content'
          ]
          )
end

def compile type, js, coffee, ckup = nil, init = nil
  case type
  when :coffee
    `cat src/cs/#{coffee[0]}.coffee > tmp.coffee`
    coffee[1..-2].each do |file|
      `cat src/cs/#{file}.coffee >> tmp.coffee`
    end
    `coffee -c tmp.coffee`
    `rm tmp.coffee`
    `cat extension/js/vendor/#{js[0]}.js > tmp2.js`
    js[1..-1].each do |file|
      `cat extension/js/vendor/#{file}.js >> tmp2.js`
    end
    `cat tmp.js >> tmp2.js`
    `mv tmp2.js extension/js/#{coffee[-1]}.js`
  when :coffeekup
    `echo "#{init}" > tmp.coffee`
    `cat src/cs/#{coffee[0]}.coffee >> tmp.coffee`
    coffee[1..-1].each do |file|
      `cat src/cs/#{file}.coffee >> tmp.coffee`
      `echo "\n" >> tmp.coffee`
    end
    `cat src/coffeekup/#{ckup}.coffee >> tmp.coffee`
    `node_modules/coffeekup/bin/coffeekup -f tmp.coffee`
    `mv tmp.html extension/js/#{ckup}.html`
#    `rm tmp.coffee`
  end
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

