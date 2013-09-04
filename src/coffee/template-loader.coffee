OPTIONS = {voiceName: 'Vicki', gender: 'female', volume: 0.4}

speak = (text, opts) ->
  _.extend opts, OPTIONS
  chrome.tts.speak text, opts

session_times = 0

$(document).ready ->
  init_commands_by_context()
  load_data()
  append_template()
  $('body').click (event) ->
    session_times++

    if session_times > 1
      display_message """
Dear Ferro user,
<br><br>
Please be advised that your current use of a mouse is unadvisedly inefficient. It must have taken your hand at least 150 milliseconds to travel from your keyboard to your mouse. That's longer than a round-trip transatlantic IP packet. If you were to try using Ferro with a mouse once a day, you would lose almost a minute of your life every year. And life is precious. And that is why we do not condone mouse usage with Ferro. Carpe diem, dear Ferro user. Carpe diem.
<br><br>
Yours sincerely,<br>
Loren
<br><br>
<audio src="egg.ogg" controls></audio>
"""
      $('audio').click (e) ->
        e.stopPropagation()
    

    chrome.storage.sync.get 'times', (data) ->
      # autoplay is annoying
      # unless data?.times
      #   $('audio')[0].play()

      times = (data?.times or 0) + 1
      chrome.storage.sync.set {times}
    
      if session_times > 2
        speak 'You have clicked Ferro ' + times + ' times.', {rate: 2}
        $.get 'http://www.iheartquotes.com/api/v1/random?source=starwars&format=json', (data) ->
          speak data.quote, {enqueue: true, rate: 1.3}

  