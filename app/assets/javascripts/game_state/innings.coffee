class window.Innings
    constructor: ->
      @count = 0
      @number = 0
      @top = true
      @score = 0

    next: =>
      if(this.number <= 10)
        if(this.score == 0)
          if(which_lineup().name == "home")
            $("#home-inning-row [data-number='"+innings.number+"']").html(innings.score)
          else if(which_lineup().name == "away")
            $("#away-inning-row [data-number='"+innings.number+"']").html(innings.score)
      this.score = 0
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
