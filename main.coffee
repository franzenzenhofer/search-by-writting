_DEBUG_ = true
d = (m) -> console.log(m) if _DEBUG_ 

_last_word_ = ''
_eraser_ = false

speak = (text, opt) ->
  text = text.trim()
  out_loud = new SpeechSynthesisUtterance()
  out_loud.onerror = (e) -> d(e)
  for k, v of opt
    if k is 'voice'
      voices = window.speechSynthesis.getVoices()
      out_loud.voice = voices[v]
    else
      out_loud[k]=v
  out_loud.text = text
  if window.speechSynthesis.speaking is false
    window.speechSynthesis.speak(out_loud)

speak('Welcome to Search by writing', opt = 
    rate: 1.2
    pitch: 1.1
    voice: 3
  )

resetCanvas = (c) ->
  ctx = c.getContext('2d')
  ctx.fillStyle = 'white'
  ctx.fillRect(0, 0, c.width, c.height)
  ctx.fillStyle = "black"

drawCircle = (ctx,x,y,r) ->
  ctx.beginPath()
  ctx.arc(((0.5 + x) | 0),((0.5 + y) | 0),((0.5 + r) | 0), 0,2*Math.PI)
  ctx.fill()

canvas2Drawingboard = (c) ->
  resetCanvas(c)
  ctx = c.getContext('2d')
  draw = false
  r = 16

  move = (e) ->
    e.preventDefault()
    if _eraser_ is true
      ctx.fillStyle = "white"
    else
      ctx.fillStyle = "black"

    rect = c.getBoundingClientRect()
    x = e.pageX - rect.left - r/2
    y = e.pageY - rect.top - r/2
    #ctx.fillRect(x, y, r, r) if draw
    drawCircle(ctx,x,y,r) if draw

  c.addEventListener('mousedown', (e) -> draw = true; move(e))
  c.addEventListener('touchstart', (e) -> draw = true; move(e))
  #window.document.addEventListener('mouseup', (e) -> draw = false)
  c.addEventListener('mouseup', (e) -> draw = false)
  c.addEventListener('touchend', (e) -> draw = false)
  c.addEventListener('mousemove', move)
  c.addEventListener('touchmove', move)

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

window.document.getElementById('eraser').addEventListener('click', (
  () ->
    er = window.document.getElementById('eraser') 
    if er.innerHTML is "eraser"
      _eraser_ = true
      er.innerHTML = "draw"
    else
      _eraser_ = false
      er.innerHTML = "eraser"
  )
)



