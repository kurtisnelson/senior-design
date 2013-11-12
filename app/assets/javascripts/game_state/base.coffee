class window.Base
    constructor: (@name) ->
      @player = []

    set: (obj) =>
      @player.push(obj)
      @render()

    reset: =>
      @player = []
      @render()

    is_empty: =>
      _.isEmpty @player

    popover_hide: =>
      $('#'+this.name).popover('hide')

    popover_show: =>
      $('#'+this.name).popover('show')

    render: =>
      if !@is_empty()
        $("#"+@name+">h4").text(@player[0]['number'])
        $("#"+@name).fadeIn()
        update_popover("#"+this.name , @player[0]['name'])
      else
        $("#"+this.name).fadeOut()
