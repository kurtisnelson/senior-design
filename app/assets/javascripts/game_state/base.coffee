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
      return true if @player.length <= 0
      false

    popover_hide: =>
      $('#'+this.name).popover('hide')

    popover_show: =>
      $('#'+this.name).popover('show')

    render: =>
      if !@is_empty()
        $("#"+@name+">h4").text(@player[0]['user_id'])
        $("#"+@name).fadeIn()
        update_popover("#"+this.name , @player[0]['name'])
      else
        $("#"+this.name).fadeOut()
