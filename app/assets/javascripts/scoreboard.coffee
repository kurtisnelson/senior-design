strike =
  counter: 0
  process: () ->
    this.counter++
    if this.counter == 3
      this.counter = 0
      ball.reset()
    this.render()
  reset: ->
    this.counter = 0
    this.render()
  render: () ->
    if this.counter == 0
      $("#strike1").hide()
      $("#strike2").hide()
    else if this.counter == 1
      $("#strike1").fadeIn()
    else if this.counter == 2
      $("#strike2").fadeIn()

ball =
  counter: 0
  process: () ->
    this.counter++
    if this.counter == 4
      this.counter = 0
      strike.counter = 0
      strike.render()
      out.counter=0
      out.render()
    this.render()
  reset: ->
      this.counter = 0
      this.render()
  render: () ->
    if this.counter == 0
      $("#ball1").hide()
      $("#ball2").hide()
      $("#ball3").hide()
    else if this.counter == 1
      $("#ball1").fadeIn()
    else if this.counter == 2
      $("#ball2").fadeIn()
    else if this.counter == 3
      $("#ball3").fadeIn()

out =
  counter: 0
  process: () ->
    this.counter++
    this.counter = 0 if this.counter == 3
    ball.reset()
    strike.reset()
    this.render()
  render: () ->
    if this.counter == 0
      $("#out1").hide()
      $("#out2").hide()
    else if this.counter == 1
      $("#out1").fadeIn()
    else if this.counter == 2
      $("#out2").fadeIn()



@do_strike = () ->
  #server call
  if strike.counter == 2
    out.process()
  else
    strike.process()

@do_ball = () ->
  #server call
  #TODO(rfahsel3) call move base on 4th ball
  ball.process()

@do_out = () ->
  #Server call
  #TODO next_innint if out.counter = 2
  out.process()






