class window.Lineup
  constructor: (@name) ->
      @batting_order = []
      @at_bat = {}
      @counter = 0

  next: =>
      @at_bat = @batting_order[@counter]
      @inc_counter()
      return @at_bat

  inc_counter: =>
      @counter++
      @counter = @counter % 9
