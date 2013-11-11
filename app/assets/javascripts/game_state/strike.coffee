class window.Strike
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
        $("#strike1").fadeIn()
        $("#strike2").fadeIn()
