#https://github.com/documentcloud/backbone/raw/master/backbone.js
#https://github.com/douglascrockford/JSON-js/raw/master/json2.js

task :default => :watch

task :watch do
  exec 'coffee -cw -o extension/js/ src/cs/'
  exec 'sass --watch src/sass/:extension/'
  exec 'coffeekup -fw -o extension/js/ src/coffeekup/'
end

def exec cmd
  Thread.new(cmd) do |tcmd|
    IO.popen tcmd do |fd|
      until fd.eof?
       puts fd.readline
      end
    end
  end
end

