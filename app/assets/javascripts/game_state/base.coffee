class window.Base
    constructor: (@name) ->
      @player = []

    set: (obj) =>
      if(obj==null)
        console.log("You tried to set a null object")
        return
      else
        @player.push(obj)

    reset: =>
      @player = []

    is_empty: =>
      _.isEmpty @player

    popover_hide: =>
      $('#'+@name).popover('hide')

    popover_show: =>
      $('#'+@name).popover('show')

    render: =>
      if !@is_empty()
        $("#"+@name+">h4").text(@player[0]['number'])
        $("#"+@name).fadeIn()
        update_popover("#"+this.name , @player[0]['name'])
      else
        $("#"+@name).fadeOut()
