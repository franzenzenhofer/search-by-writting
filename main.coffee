_DEBUG_ = true
d = (m) -> console.log(m) if _DEBUG_ 
_last_word_ = ''

speak = (text, opt) ->
  text = text.trim()
  out_loud = new SpeechSynthesisUtterance()
  for k, v of opt
    d(k)
    d(v)
    if k is 'voice'
      d('set voice')
      d(window.speechSynthesis.getVoices())
      voices = window.speechSynthesis.getVoices()
      out_loud.voice = voices[v]
    else
      out_loud[k]=v
  out_loud.text = text
  window.speechSynthesis.speak(out_loud)

speak('Welcome to Search by Writting', opt = 
    rate: 1
    pitch: 1
    voice: 10
  )

resetCanvas = (c) ->
  ctx = c.getContext('2d')
  ctx.fillStyle = 'white'
  ctx.fillRect(0, 0, c.width, c.height)
  ctx.fillStyle = "black"

canvas2Drawingboard = (c) ->
  resetCanvas(c)
  ctx = c.getContext('2d')
  draw = false
  r = 20

  move = (e) ->
    e.preventDefault()
    rect = c.getBoundingClientRect()
    x = Math.round(e.clientX - rect.left - r/2)
    y = Math.round(e.clientY - rect.top - r/2)
    ctx.fillRect(x, y, r, r) if draw

  c.addEventListener('mousedown', (e) ->
    draw = true
    move(e)
  )
  #window.document.addEventListener('mouseup', (e) -> draw = false)
  c.addEventListener('mouseup', (e) -> draw = false)
  c.addEventListener('mousemove', move)

canvas2Drawingboard(window.document.getElementById('board'))

window.document.getElementById('board').addEventListener('mouseup', (e) -> 
  c = window.document.getElementById('board')
  _last_word_ = OCRAD(c)
  _last_word_ = _last_word_.trim()
  speak(_last_word_)
  console.log(_last_word_)
)

window.document.getElementById('reset').addEventListener('click', (() -> resetCanvas(window.document.getElementById('board'))))

window.document.getElementById('google').addEventListener('click', (() -> window.document.location = "https://www.google.com/search?q="+encodeURIComponent(_last_word_)+"&pws=0&hl=en"))




