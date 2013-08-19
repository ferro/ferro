# used for getferro.com

{exec} = require 'child_process'

compile_cs = (cs, js) ->  
  exec "coffee -bw --compile --output #{js} #{cs}", (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr

compile_from_extension = (files...) ->
  for file in files
    compile_cs "src/coffee/#{file}.coffee", 'server/public/js/'

task 'build', 'Build client js and css for getferro.com', ->
  compile_cs 'server/client/', 'server/public/js/'
  compile_from_extension 'donate', 'init', 'analytics'
  exec 'sass --load-path=src/sass/ --watch server/client/:server/public/css'