require 'crxmake'

#https://github.com/documentcloud/backbone/raw/master/backbone.js
#https://github.com/douglascrockford/JSON-js/raw/master/json2.js

task :default => :compile

task :watch do
  exec 'coffee -cw -o extension/js/ src/cs/'
  exec 'sass --watch src/sass/:extension/'
  exec 'coffeekup -fw -o extension/js/ src/coffeekup/options.coffee'
end

task :sass do
  #  `node_modules/coffeekup/bin/coffeekup -fw -o extension/js/ src/coffeekup/options.coffee &`
  `sass --watch src/sass/:extension/css/`
end

task :compile => [:options_template, :options, :background, :content, :sass]

task :options_template do
  compile(
          [],
          [
           'init',
           'chrome-pages',
           'commands'
          ],
          {
            ckup: 'options',
            pre: "
window = {}
f = {}
",
            ckup_only: true
          }
          )
end

task :options do
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
           'options-backbone',
           'options'
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
          ],
          {
#             pre: "
# <script type=text/javascript>
# ",
#             post: "
# </script>
# ",
#            ext: 'html',
#            dest: 'extension'
          }
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
          ],
          ckup: 'ferro'
          )
end

def compile js, coffee, opts = {}
  if opts[:ckup_only]
    `echo "#{opts[:pre]}" > tmp.coffee`
    `cat src/cs/#{coffee[0]}.coffee >> tmp.coffee`
    coffee[1..-1].each do |file|
      `echo "\n" >> tmp.coffee`
      `cat src/cs/#{file}.coffee >> tmp.coffee`
    end
    `echo "\n" >> tmp.coffee`
    `cat src/coffeekup/#{opts[:ckup]}.coffee >> tmp.coffee`
    `node_modules/coffeekup/bin/coffeekup -f tmp.coffee`
    `mv tmp.html extension/#{opts[:ckup]}.html`
    #    `rm tmp.coffee`

  else
    `cat src/cs/#{coffee[0]}.coffee > tmp.coffee`
    coffee[1..-2].each do |file|
      `echo "\n" >> tmp.coffee`
      `cat src/cs/#{file}.coffee >> tmp.coffee`
    end
    `coffee -c tmp.coffee`
    #    `rm tmp.coffee`

    if ENV['env'] == 'production'
      js.each do |s|
        s << '.min'
      end
    end

    `echo "#{opts[:pre]}" > tmp2.js`
    `cat extension/js/vendor/#{js[0]}.js >> tmp2.js`
    `echo "\n" >> tmp2.js`
    js[1..-1].each do |file|
      `cat extension/js/vendor/#{file}.js >> tmp2.js`
    end

    `cat tmp.js >> tmp2.js`

    if opts[:ckup]
      `node_modules/coffeekup/bin/coffeekup --js src/coffeekup/#{opts[:ckup]}.coffee`
      `cat src/coffeekup/#{opts[:ckup]}.js >> tmp2.js`
    end

    `echo "#{opts[:post]}" >> tmp2.js`
    opts[:ext] ||= 'js'
    opts[:dest] ||= 'extension/js'
    `mv tmp2.js #{opts[:dest]}/#{coffee[-1]}.#{opts[:ext]}`
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
  get 'http://epeli.github.com/underscore.string/lib/underscore.string.js'
  get 'http://documentcloud.github.com/backbone/backbone.js'
end

def get url, name = nil
  name = url[url.rindex('/')+1..-1] unless name
  `wget #{url} -O extension/js/vendor/#{name}`
end

task :make do
  CrxMake.make(
               :ex_dir => "./extension",
               :pkey   => "~/.ssh/ferro.pem",
               :crx_output => "./ferro.crx",
               :verbose => true,
               :ignorefile => /.*~/,
#               :ignoredir => /\.(?:svn|git|cvs)/
               )
end
