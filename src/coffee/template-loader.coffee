$(document).ready ->
  console.log 'template loader, document.ready'
  init()
  refresh_all()
  append_template()
  $('body').click (event) ->
    $('body').empty()
    $('body').html '''
<audio src="egg.ogg"></audio>
Dear Ferro user,
<br><br>
Please be advised that your current use of a mouse is unadvisedly inefficient. It must have taken your hand at least 150 milliseconds to travel from your keyboard to your mouse. That's longer than a round-trip transatlantic IP packet. If you were to try using Ferro with a mouse once a day, you would lose almost a minute of your life every year. And life is precious. And this is why we do not condone mouse usage with Ferro. Carpe diem, dear Ferro user. Carpe diem.
<br><br>
Yours sincerely,<br>
Loren'''
    $('audio')[0].play()

  