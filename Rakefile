#https://github.com/documentcloud/backbone/raw/master/backbone.js
#https://github.com/douglascrockford/JSON-js/raw/master/json2.js

task :default => :watch

task :watch do
  exec 'coffee -cw -o extension/compiled/ src/cs/'
  exec 'sass --watch src/sass/:extension/compiled/'
  exec 'coffeekup -fw -o extension/compiled/ src/coffeekup/'

  while true
  end
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

