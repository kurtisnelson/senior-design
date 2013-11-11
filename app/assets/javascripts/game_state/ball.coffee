class window.Ball
    counter: 0
    process: () ->
      this.counter++
      if this.counter == 4
        this.counter = 0
        strike.counter = 0
        strike.render()
        #out.counter=0
        do_walk()
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
        $("#ball1").fadeIn()
        $("#ball2").fadeIn()
      else if this.counter == 3
        $("#ball1").fadeIn()
        $("#ball2").fadeIn()      
        $("#ball3").fadeIn()
