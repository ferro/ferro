OPTIONS = {voiceName: 'Vicki', gender: 'female', volume: 0.4}

speak = (text, opts) ->
  _.extend opts, OPTIONS
  chrome.tts.speak text, opts

$(document).ready ->
  z 'template loader, document.ready'
  init_commands_by_context()
  z COMMANDS_BY_CONTEXT
  load_data()
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
      speak 'You have clicked Ferro ' + times + ' times.', {rate: 2}
      $.get 'http://www.iheartquotes.com/api/v1/random?source=starwars&format=json', (data) ->
        speak data.quote, {enqueue: true, rate: 1.3}

  