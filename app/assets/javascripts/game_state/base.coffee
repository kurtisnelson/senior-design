class window.Base
    constructor: (@name) ->
      @player = []
      this.isEmpty = true

    set: (obj) =>
      if(obj==null)
        console.log("You tried to set a null object")
        this.isEmpty = true
        return
      else
        if typeof @player[0] == 'undefined'
          @player[0] = obj
          this.isEmpty = false
        else
          @player.push(obj)

    reset: =>
      @player = []
      this.isEmpty = true

    is_empty: =>
      return this.isEmpty

    popover_hide: =>
      $('#'+@name).popover('hide')

    popover_show: =>
      $('#'+@name).popover('show')

    render: =>
      if !@is_empty() && typeof @player[0] != 'undefined'
        $("#"+@name+">h4").text(@player[0]['number'])
        $("#"+@name).fadeIn()
        update_popover("#"+this.name , @player[0]['name'])
      else
        $("#"+@name).fadeOut()
