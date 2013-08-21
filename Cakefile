# used for getferro.com

{exec} = require 'child_process'

compile_cs = (cs, js, watch) ->  
  exec "coffee -b#{if watch then 'w' else ''}  --compile --output #{js} #{cs}", (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr

compile_from_extension = (files..., watch) ->
  for file in files
    compile_cs "src/coffee/#{file}.coffee", 'server/public/js/', watch

build = (watch) ->
  compile_cs 'server/client/', 'server/public/js/', watch
  compile_from_extension 'donate', 'init', 'analytics', watch
  exec "sass --load-path=src/sass/ #{'--watch' if watch} server/client/:server/public/css"

task 'build', 'Build client js and css for getferro.com', ->
  build false

task 'watch', 'Watch', ->
  build true