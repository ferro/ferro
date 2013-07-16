$(document).ready ->
  console.log 'template loader, document.ready'
  d 'command names'
  d COMMAND_NAMES
  init()
  refresh_all()
  append_template()
  $('body').click (event) ->
    unless $('audio')[0]
      display_message '''
Dear Ferro user,
<br><br>
Please be advised that your current use of a mouse is unadvisedly inefficient. It must have taken your hand at least 150 milliseconds to travel from your keyboard to your mouse. That's longer than a round-trip transatlantic IP packet. If you were to try using Ferro with a mouse once a day, you would lose almost a minute of your life every year. And life is precious. And this is why we do not condone mouse usage with Ferro. Carpe diem, dear Ferro user. Carpe diem.
<br><br>
Yours sincerely,<br>
Loren
<br><br>
<audio src="egg.ogg" controls></audio>
'''
      $('audio').click (e) ->
        e.stopPropagation()

    unless localStorage.times
      localStorage.times = '0'
      $('audio')[0].play()
    times = parseInt(localStorage.times) + 1
    localStorage.times = times
    if times > 1
      chrome.tts.speak 'You have clicked Ferro ' + times + ' times.'
      $.get 'http://www.iheartquotes.com/api/v1/random?source=starwars&format=json', (data) ->
        chrome.tts.speak data.quote, {enqueue: true, rate: 1.0}

  