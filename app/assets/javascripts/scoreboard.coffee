strike =
  counter: 0
  process: () ->
    this.counter++
    if this.counter == 3
      this.counter = 0
      ball.counter = 0
      ball.render()
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



@do_strike = () ->
  #server call
  strike.process()

@do_ball = () ->
  ball.process()

