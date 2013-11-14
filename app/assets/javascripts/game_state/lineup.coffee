class window.Lineup
  constructor: (@name) ->
      @batting_order = []

  next: =>
      @batting_order.push(@batting_order.shift())
      return @at_bat()

  at_bat: =>
      @batting_order[0]
