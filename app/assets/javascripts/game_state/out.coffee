class window.Out
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
        $("#out1").fadeIn()    
        $("#out2").fadeIn()
