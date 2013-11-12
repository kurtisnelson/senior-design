class window.Innings
    constructor: ->
      @count = 0
      @number = 0
      @top = true
      @score = 0

    next: =>
      @score = 0
      if(this.count >= 19 and home_score != away_score)
        #game over
        console.log "game over"
        $("#strikeBtn").fadeOut()
        $("#ballBtn").fadeOut()
      else
        this.count++
        this.number = Math.floor(this.count / 2)
        if(this.count % 2 == 0)
          this.top= true
        else
          this.top= false
        do_nextup()

    set_number: (num) =>
      @number = num
      @calc_count()

    calc_count: =>
      if @top
        @count = @number * 2
      else
        @count = @number * 2 + 1
