class window.Lineup
  constructor: (@name) ->
      @batting_order = []
      @counter = 0

  next: =>
      at_bat = @batting_order[@counter]
      @inc_counter()
      return at_bat

  at_bat: =>
      @batting_order[@counter]

  inc_counter: =>
      @counter++
      @counter = @counter % 9
      @counter = @counter % @batting_order.length
